// generated by codegen/codegen.py, do not edit
/**
 * This module provides the generated definition of `CapturedDecl`.
 * INTERNAL: Do not import directly.
 */

private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.internal.DeclImpl::Impl as DeclImpl
import codeql.swift.elements.decl.ValueDecl

/**
 * INTERNAL: This module contains the fully generated definition of `CapturedDecl` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::CapturedDecl` class directly.
   * Use the subclass `CapturedDecl`, where the following predicates are available.
   */
  class CapturedDecl extends Synth::TCapturedDecl, DeclImpl::Decl {
    override string getAPrimaryQlClass() { result = "CapturedDecl" }

    /**
     * Gets the the declaration captured by the parent closure.
     */
    ValueDecl getDecl() {
      result =
        Synth::convertValueDeclFromRaw(Synth::convertCapturedDeclToRaw(this)
              .(Raw::CapturedDecl)
              .getDecl())
    }

    /**
     * Holds if this captured declaration is direct.
     */
    predicate isDirect() { Synth::convertCapturedDeclToRaw(this).(Raw::CapturedDecl).isDirect() }

    /**
     * Holds if this captured declaration is escaping.
     */
    predicate isEscaping() {
      Synth::convertCapturedDeclToRaw(this).(Raw::CapturedDecl).isEscaping()
    }
  }
}
