// generated by codegen, do not edit
/**
 * This module provides the generated definition of `PathSegment`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
import codeql.rust.elements.GenericArgList
import codeql.rust.elements.NameRef
import codeql.rust.elements.ParamList
import codeql.rust.elements.PathTypeRepr
import codeql.rust.elements.RetTypeRepr
import codeql.rust.elements.ReturnTypeSyntax
import codeql.rust.elements.TypeRepr

/**
 * INTERNAL: This module contains the fully generated definition of `PathSegment` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A path segment, which is one part of a whole path.
   * INTERNAL: Do not reference the `Generated::PathSegment` class directly.
   * Use the subclass `PathSegment`, where the following predicates are available.
   */
  class PathSegment extends Synth::TPathSegment, AstNodeImpl::AstNode {
    override string getAPrimaryQlClass() { result = "PathSegment" }

    /**
     * Gets the generic argument list of this path segment, if it exists.
     */
    GenericArgList getGenericArgList() {
      result =
        Synth::convertGenericArgListFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getGenericArgList())
    }

    /**
     * Holds if `getGenericArgList()` exists.
     */
    final predicate hasGenericArgList() { exists(this.getGenericArgList()) }

    /**
     * Gets the name reference of this path segment, if it exists.
     */
    NameRef getNameRef() {
      result =
        Synth::convertNameRefFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getNameRef())
    }

    /**
     * Holds if `getNameRef()` exists.
     */
    final predicate hasNameRef() { exists(this.getNameRef()) }

    /**
     * Gets the parameter list of this path segment, if it exists.
     */
    ParamList getParamList() {
      result =
        Synth::convertParamListFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getParamList())
    }

    /**
     * Holds if `getParamList()` exists.
     */
    final predicate hasParamList() { exists(this.getParamList()) }

    /**
     * Gets the path type of this path segment, if it exists.
     */
    PathTypeRepr getPathType() {
      result =
        Synth::convertPathTypeReprFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getPathType())
    }

    /**
     * Holds if `getPathType()` exists.
     */
    final predicate hasPathType() { exists(this.getPathType()) }

    /**
     * Gets the ret type of this path segment, if it exists.
     */
    RetTypeRepr getRetType() {
      result =
        Synth::convertRetTypeReprFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getRetType())
    }

    /**
     * Holds if `getRetType()` exists.
     */
    final predicate hasRetType() { exists(this.getRetType()) }

    /**
     * Gets the return type syntax of this path segment, if it exists.
     */
    ReturnTypeSyntax getReturnTypeSyntax() {
      result =
        Synth::convertReturnTypeSyntaxFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getReturnTypeSyntax())
    }

    /**
     * Holds if `getReturnTypeSyntax()` exists.
     */
    final predicate hasReturnTypeSyntax() { exists(this.getReturnTypeSyntax()) }

    /**
     * Gets the type representation of this path segment, if it exists.
     */
    TypeRepr getTypeRepr() {
      result =
        Synth::convertTypeReprFromRaw(Synth::convertPathSegmentToRaw(this)
              .(Raw::PathSegment)
              .getTypeRepr())
    }

    /**
     * Holds if `getTypeRepr()` exists.
     */
    final predicate hasTypeRepr() { exists(this.getTypeRepr()) }
  }
}
