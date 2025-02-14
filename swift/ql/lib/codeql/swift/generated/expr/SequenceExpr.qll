// generated by codegen/codegen.py, do not edit
/**
 * This module provides the generated definition of `SequenceExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.expr.internal.ExprImpl::Impl as ExprImpl

/**
 * INTERNAL: This module contains the fully generated definition of `SequenceExpr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::SequenceExpr` class directly.
   * Use the subclass `SequenceExpr`, where the following predicates are available.
   */
  class SequenceExpr extends Synth::TSequenceExpr, ExprImpl::Expr {
    override string getAPrimaryQlClass() { result = "SequenceExpr" }

    /**
     * Gets the `index`th element of this sequence expression (0-based).
     *
     * This includes nodes from the "hidden" AST. It can be overridden in subclasses to change the
     * behavior of both the `Immediate` and non-`Immediate` versions.
     */
    Expr getImmediateElement(int index) {
      result =
        Synth::convertExprFromRaw(Synth::convertSequenceExprToRaw(this)
              .(Raw::SequenceExpr)
              .getElement(index))
    }

    /**
     * Gets the `index`th element of this sequence expression (0-based).
     */
    final Expr getElement(int index) {
      exists(Expr immediate |
        immediate = this.getImmediateElement(index) and
        if exists(this.getResolveStep()) then result = immediate else result = immediate.resolve()
      )
    }

    /**
     * Gets any of the elements of this sequence expression.
     */
    final Expr getAnElement() { result = this.getElement(_) }

    /**
     * Gets the number of elements of this sequence expression.
     */
    final int getNumberOfElements() { result = count(int i | exists(this.getElement(i))) }
  }
}
