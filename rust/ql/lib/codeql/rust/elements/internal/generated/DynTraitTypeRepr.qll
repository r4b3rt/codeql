// generated by codegen, do not edit
/**
 * This module provides the generated definition of `DynTraitTypeRepr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.TypeBoundList
import codeql.rust.elements.internal.TypeReprImpl::Impl as TypeReprImpl

/**
 * INTERNAL: This module contains the fully generated definition of `DynTraitTypeRepr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A DynTraitTypeRepr. For example:
   * ```rust
   * todo!()
   * ```
   * INTERNAL: Do not reference the `Generated::DynTraitTypeRepr` class directly.
   * Use the subclass `DynTraitTypeRepr`, where the following predicates are available.
   */
  class DynTraitTypeRepr extends Synth::TDynTraitTypeRepr, TypeReprImpl::TypeRepr {
    override string getAPrimaryQlClass() { result = "DynTraitTypeRepr" }

    /**
     * Gets the type bound list of this dyn trait type representation, if it exists.
     */
    TypeBoundList getTypeBoundList() {
      result =
        Synth::convertTypeBoundListFromRaw(Synth::convertDynTraitTypeReprToRaw(this)
              .(Raw::DynTraitTypeRepr)
              .getTypeBoundList())
    }

    /**
     * Holds if `getTypeBoundList()` exists.
     */
    final predicate hasTypeBoundList() { exists(this.getTypeBoundList()) }
  }
}
