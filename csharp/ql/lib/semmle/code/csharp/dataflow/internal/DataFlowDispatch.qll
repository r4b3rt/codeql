private import csharp
private import cil
private import dotnet
private import DataFlowImplCommon as DataFlowImplCommon
private import DataFlowPublic
private import DataFlowPrivate
private import FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.FlowSummary as FlowSummary
private import semmle.code.csharp.dispatch.Dispatch
private import semmle.code.csharp.dispatch.RuntimeCallable
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

/**
 * Gets a source declaration of callable `c` that has a body or has
 * a flow summary.
 *
 * If the callable has both CIL and source code, return only the source
 * code version.
 */
DotNet::Callable getCallableForDataFlow(DotNet::Callable c) {
  exists(DotNet::Callable unboundDecl | unboundDecl = c.getUnboundDeclaration() |
    (
      result.hasBody()
      or
      // take synthesized bodies into account, e.g. implicit constructors
      // with field initializer assignments
      result = any(ControlFlow::Nodes::ElementNode n).getEnclosingCallable()
    ) and
    if unboundDecl.getFile().fromSource()
    then
      // C# callable with C# implementation in the database
      result = unboundDecl
    else
      if unboundDecl instanceof CIL::Callable
      then
        // CIL callable with C# implementation in the database
        unboundDecl.matchesHandle(result.(Callable))
        or
        // CIL callable without C# implementation in the database
        not unboundDecl.matchesHandle(any(Callable k | k.hasBody())) and
        result = unboundDecl
      else
        // C# callable without C# implementation in the database
        unboundDecl.matchesHandle(result.(CIL::Callable))
  )
}

/**
 * Holds if `cfn` corresponds to a call that can reach callable `c` using
 * additional calls, and `c` is a callable that either reads or writes to
 * a captured variable.
 */
private predicate transitiveCapturedCallTarget(ControlFlow::Nodes::ElementNode cfn, Callable c) {
  exists(Ssa::ExplicitDefinition def |
    exists(Ssa::ImplicitEntryDefinition edef |
      def.isCapturedVariableDefinitionFlowIn(edef, cfn, true)
    |
      c = edef.getCallable()
    )
    or
    exists(Ssa::ImplicitCallDefinition cdef | def.isCapturedVariableDefinitionFlowOut(cdef, true) |
      cfn = cdef.getControlFlowNode() and
      c = def.getEnclosingCallable()
    )
  )
}

newtype TReturnKind =
  TNormalReturnKind() or
  TOutReturnKind(int i) { i = any(Parameter p | p.isOut()).getPosition() } or
  TRefReturnKind(int i) { i = any(Parameter p | p.isRef()).getPosition() } or
  TImplicitCapturedReturnKind(LocalScopeVariable v) {
    exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowOut(_, _) |
      v = def.getSourceVariable().getAssignable()
    )
  }

/**
 * A summarized callable where the summary should be used for dataflow analysis.
 */
class DataFlowSummarizedCallable instanceof FlowSummary::SummarizedCallable {
  DataFlowSummarizedCallable() {
    not this.fromSource()
    or
    this.fromSource() and not this.applyGeneratedModel()
  }

  string toString() { result = super.toString() }
}

private module Cached {
  /**
   * The following heuristic is used to rank when to use source code or when to use summaries for DataFlowCallables.
   * 1. Use hand written summaries or source code.
   * 2. Use auto generated summaries.
   */
  cached
  newtype TDataFlowCallable =
    TDotNetCallable(DotNet::Callable c) { c.isUnboundDeclaration() } or
    TSummarizedCallable(DataFlowSummarizedCallable sc)

  cached
  newtype TDataFlowCall =
    TNonDelegateCall(ControlFlow::Nodes::ElementNode cfn, DispatchCall dc) {
      DataFlowImplCommon::forceCachingInSameStage() and
      cfn.getAstNode() = dc.getCall()
    } or
    TExplicitDelegateLikeCall(ControlFlow::Nodes::ElementNode cfn, DelegateLikeCall dc) {
      cfn.getAstNode() = dc
    } or
    TTransitiveCapturedCall(ControlFlow::Nodes::ElementNode cfn, Callable target) {
      transitiveCapturedCallTarget(cfn, target)
    } or
    TCilCall(CIL::Call call) {
      // No need to include calls that are compiled from source
      not call.getImplementation().getMethod().compiledFromSource()
    } or
    TSummaryCall(
      FlowSummaryImpl::Public::SummarizedCallable c, FlowSummaryImpl::Private::SummaryNode receiver
    ) {
      FlowSummaryImpl::Private::summaryCallbackRange(c, receiver)
    }

  /** Gets a viable run-time target for the call `call`. */
  cached
  DataFlowCallable viableCallable(DataFlowCall call) { result = call.getARuntimeTarget() }

  private predicate capturedWithFlowIn(LocalScopeVariable v) {
    exists(Ssa::ExplicitDefinition def | def.isCapturedVariableDefinitionFlowIn(_, _, _) |
      v = def.getSourceVariable().getAssignable()
    )
  }

  cached
  newtype TParameterPosition =
    TPositionalParameterPosition(int i) { i = any(Parameter p).getPosition() } or
    TThisParameterPosition() or
    TImplicitCapturedParameterPosition(LocalScopeVariable v) { capturedWithFlowIn(v) }

  cached
  newtype TArgumentPosition =
    TPositionalArgumentPosition(int i) { i = any(Parameter p).getPosition() } or
    TQualifierArgumentPosition() or
    TImplicitCapturedArgumentPosition(LocalScopeVariable v) { capturedWithFlowIn(v) }
}

import Cached

private module DispatchImpl {
  /**
   * Holds if the set of viable implementations that can be called by `call`
   * might be improved by knowing the call context. This is the case if the
   * call is a delegate call, or if the qualifier accesses a parameter of
   * the enclosing callable `c` (including the implicit `this` parameter).
   */
  predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c) {
    c = call.getEnclosingCallable() and
    call.(NonDelegateDataFlowCall).getDispatchCall().mayBenefitFromCallContext()
  }

  /**
   * Gets a viable dispatch target of `call` in the context `ctx`. This is
   * restricted to those `call`s for which a context might make a difference.
   */
  DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
    exists(DispatchCall dc | dc = call.(NonDelegateDataFlowCall).getDispatchCall() |
      result.getUnderlyingCallable() =
        getCallableForDataFlow(dc.getADynamicTargetInCallContext(ctx.(NonDelegateDataFlowCall)
                .getDispatchCall()).getUnboundDeclaration())
      or
      exists(Callable c, DataFlowCallable encl |
        result.asSummarizedCallable() = c and
        mayBenefitFromCallContext(call, encl) and
        encl = ctx.getARuntimeTarget() and
        c = dc.getAStaticTarget().getUnboundDeclaration() and
        not c instanceof RuntimeCallable
      )
    )
  }
}

import DispatchImpl

/**
 * Gets a node that can read the value returned from `call` with return kind
 * `kind`.
 */
OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) { call = result.getCall(kind) }

/**
 * A return kind. A return kind describes how a value can be returned
 * from a callable.
 */
abstract class ReturnKind extends TReturnKind {
  /** Gets a textual representation of this position. */
  abstract string toString();
}

/**
 * A value returned from a callable using a `return` statement or an expression
 * body, that is, a "normal" return.
 */
class NormalReturnKind extends ReturnKind, TNormalReturnKind {
  override string toString() { result = "normal" }
}

/** A value returned from a callable using an `out` or a `ref` parameter. */
abstract class OutRefReturnKind extends ReturnKind {
  /** Gets the position of the `out`/`ref` parameter. */
  abstract int getPosition();
}

/** A value returned from a callable using an `out` parameter. */
class OutReturnKind extends OutRefReturnKind, TOutReturnKind {
  private int pos;

  OutReturnKind() { this = TOutReturnKind(pos) }

  override int getPosition() { result = pos }

  override string toString() { result = "out parameter " + pos }
}

/** A value returned from a callable using a `ref` parameter. */
class RefReturnKind extends OutRefReturnKind, TRefReturnKind {
  private int pos;

  RefReturnKind() { this = TRefReturnKind(pos) }

  override int getPosition() { result = pos }

  override string toString() { result = "ref parameter " + pos }
}

/** A value implicitly returned from a callable using a captured variable. */
class ImplicitCapturedReturnKind extends ReturnKind, TImplicitCapturedReturnKind {
  private LocalScopeVariable v;

  ImplicitCapturedReturnKind() { this = TImplicitCapturedReturnKind(v) }

  /** Gets the captured variable. */
  LocalScopeVariable getVariable() { result = v }

  override string toString() { result = "captured " + v }
}

/** A callable used for data flow. */
class DataFlowCallable extends TDataFlowCallable {
  /** Get the underlying source code callable, if any. */
  DotNet::Callable asCallable() { this = TDotNetCallable(result) }

  /** Get the underlying summarized callable, if any. */
  FlowSummary::SummarizedCallable asSummarizedCallable() { this = TSummarizedCallable(result) }

  /** Get the underlying callable. */
  DotNet::Callable getUnderlyingCallable() {
    result = this.asCallable() or result = this.asSummarizedCallable()
  }

  /** Gets a textual representation of this dataflow callable. */
  string toString() { result = this.getUnderlyingCallable().toString() }

  /** Get the location of this dataflow callable. */
  Location getLocation() { result = this.getUnderlyingCallable().getLocation() }
}

/** A call relevant for data flow. */
abstract class DataFlowCall extends TDataFlowCall {
  /**
   * Gets a run-time target of this call. A target is always a source
   * declaration, and if the callable has both CIL and source code, only
   * the source code version is returned.
   */
  abstract DataFlowCallable getARuntimeTarget();

  /** Gets the control flow node where this call happens, if any. */
  abstract ControlFlow::Nodes::ElementNode getControlFlowNode();

  /** Gets the data flow node corresponding to this call, if any. */
  abstract DataFlow::Node getNode();

  /** Gets the enclosing callable of this call. */
  abstract DataFlowCallable getEnclosingCallable();

  /** Gets the underlying expression, if any. */
  final DotNet::Expr getExpr() { result = this.getNode().asExpr() }

  /** Gets the argument at position `pos` of this call. */
  final ArgumentNode getArgument(ArgumentPosition pos) { result.argumentOf(this, pos) }

  /** Gets a textual representation of this call. */
  abstract string toString();

  /** Gets the location of this call. */
  abstract Location getLocation();

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }
}

/** A non-delegate C# call relevant for data flow. */
class NonDelegateDataFlowCall extends DataFlowCall, TNonDelegateCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DispatchCall dc;

  NonDelegateDataFlowCall() { this = TNonDelegateCall(cfn, dc) }

  /** Gets the underlying call. */
  DispatchCall getDispatchCall() { result = dc }

  override DataFlowCallable getARuntimeTarget() {
    result.asCallable() = getCallableForDataFlow(dc.getADynamicTarget())
    or
    exists(Callable c, boolean static |
      result.asSummarizedCallable() = c and
      c = this.getATarget(static)
    |
      static = false
      or
      static = true and not c instanceof RuntimeCallable
    )
  }

  /** Gets a static or dynamic target of this call. */
  Callable getATarget(boolean static) {
    result = dc.getADynamicTarget().getUnboundDeclaration() and static = false
    or
    result = dc.getAStaticTarget().getUnboundDeclaration() and static = true
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = cfn.getEnclosingCallable()
  }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/** A delegate call relevant for data flow. */
abstract class DelegateDataFlowCall extends DataFlowCall { }

/** An explicit delegate or function pointer call relevant for data flow. */
class ExplicitDelegateLikeDataFlowCall extends DelegateDataFlowCall, TExplicitDelegateLikeCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private DelegateLikeCall dc;

  ExplicitDelegateLikeDataFlowCall() { this = TExplicitDelegateLikeCall(cfn, dc) }

  /** Gets the underlying call. */
  DelegateLikeCall getCall() { result = dc }

  override DataFlowCallable getARuntimeTarget() {
    none() // handled by the shared library
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { result.getControlFlowNode() = cfn }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = cfn.getEnclosingCallable()
  }

  override string toString() { result = cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/**
 * A call that can reach a callable, using one or more additional calls, which
 * reads or updates a captured variable. We model such a chain of calls as just
 * a single call for performance reasons.
 */
class TransitiveCapturedDataFlowCall extends DataFlowCall, TTransitiveCapturedCall {
  private ControlFlow::Nodes::ElementNode cfn;
  private Callable target;

  TransitiveCapturedDataFlowCall() { this = TTransitiveCapturedCall(cfn, target) }

  override DataFlowCallable getARuntimeTarget() { result.asCallable() = target }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { result = cfn }

  override DataFlow::ExprNode getNode() { none() }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = cfn.getEnclosingCallable()
  }

  override string toString() { result = "[transitive] " + cfn.toString() }

  override Location getLocation() { result = cfn.getLocation() }
}

/** A CIL call relevant for data flow. */
class CilDataFlowCall extends DataFlowCall, TCilCall {
  private CIL::Call call;

  CilDataFlowCall() { this = TCilCall(call) }

  override DataFlowCallable getARuntimeTarget() {
    // There is no dispatch library for CIL, so do not consider overrides for now
    result.getUnderlyingCallable() = getCallableForDataFlow(call.getTarget())
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::ExprNode getNode() { result.getExpr() = call }

  override DataFlowCallable getEnclosingCallable() {
    result.asCallable() = call.getEnclosingCallable()
  }

  override string toString() { result = call.toString() }

  override Location getLocation() { result = call.getLocation() }
}

/**
 * A synthesized call inside a callable with a flow summary.
 *
 * For example, in `ints.Select(i => i + 1)` there is a call to the delegate at
 * parameter position `1` (counting the qualifier as the `0`th argument) inside
 * the method `Select`.
 */
class SummaryCall extends DelegateDataFlowCall, TSummaryCall {
  private FlowSummaryImpl::Public::SummarizedCallable c;
  private FlowSummaryImpl::Private::SummaryNode receiver;

  SummaryCall() { this = TSummaryCall(c, receiver) }

  /** Gets the data flow node that this call targets. */
  FlowSummaryImpl::Private::SummaryNode getReceiver() { result = receiver }

  override DataFlowCallable getARuntimeTarget() {
    none() // handled by the shared library
  }

  override ControlFlow::Nodes::ElementNode getControlFlowNode() { none() }

  override DataFlow::Node getNode() { none() }

  override DataFlowCallable getEnclosingCallable() { result.asSummarizedCallable() = c }

  override string toString() { result = "[summary] call to " + receiver + " in " + c }

  override Location getLocation() { result = c.getLocation() }
}

/** A parameter position. */
class ParameterPosition extends TParameterPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalParameterPosition(result) }

  /** Holds if this position represents a `this` parameter. */
  predicate isThisParameter() { this = TThisParameterPosition() }

  /** Holds if this position is used to model flow through captured variables. */
  predicate isImplicitCapturedParameterPosition(LocalScopeVariable v) {
    this = TImplicitCapturedParameterPosition(v)
  }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isThisParameter() and result = "this"
    or
    exists(LocalScopeVariable v |
      this.isImplicitCapturedParameterPosition(v) and result = "captured " + v
    )
  }
}

/** An argument position. */
class ArgumentPosition extends TArgumentPosition {
  /** Gets the underlying integer position, if any. */
  int getPosition() { this = TPositionalArgumentPosition(result) }

  /** Holds if this position represents a qualifier. */
  predicate isQualifier() { this = TQualifierArgumentPosition() }

  /** Holds if this position is used to model flow through captured variables. */
  predicate isImplicitCapturedArgumentPosition(LocalScopeVariable v) {
    this = TImplicitCapturedArgumentPosition(v)
  }

  /** Gets a textual representation of this position. */
  string toString() {
    result = "position " + this.getPosition()
    or
    this.isQualifier() and result = "qualifier"
    or
    exists(LocalScopeVariable v |
      this.isImplicitCapturedArgumentPosition(v) and result = "captured " + v
    )
  }
}

/** Holds if arguments at position `apos` match parameters at position `ppos`. */
predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.getPosition() = apos.getPosition()
  or
  ppos.isThisParameter() and apos.isQualifier()
  or
  exists(LocalScopeVariable v |
    ppos.isImplicitCapturedParameterPosition(v) and
    apos.isImplicitCapturedArgumentPosition(v)
  )
}

/**
 * Holds if flow from `call`'s argument `arg` to parameter `p` is permissible.
 *
 * This is a temporary hook to support technical debt in the Go language; do not use.
 */
pragma[inline]
predicate golangSpecificParamArgFilter(DataFlowCall call, ParameterNode p, ArgumentNode arg) {
  any()
}
