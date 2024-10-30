// generated by codegen, do not edit
/**
 * This module provides the generated definition of `ConstBlockPat`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.BlockExpr
import codeql.rust.elements.internal.PatImpl::Impl as PatImpl

/**
 * INTERNAL: This module contains the fully generated definition of `ConstBlockPat` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A const block pattern. For example:
   * ```rust
   * match x {
   *     const { 1 + 2 + 3 } => "ok",
   *     _ => "fail",
   * };
   * ```
   * INTERNAL: Do not reference the `Generated::ConstBlockPat` class directly.
   * Use the subclass `ConstBlockPat`, where the following predicates are available.
   */
  class ConstBlockPat extends Synth::TConstBlockPat, PatImpl::Pat {
    override string getAPrimaryQlClass() { result = "ConstBlockPat" }

    /**
     * Gets the block expression of this const block pat, if it exists.
     */
    BlockExpr getBlockExpr() {
      result =
        Synth::convertBlockExprFromRaw(Synth::convertConstBlockPatToRaw(this)
              .(Raw::ConstBlockPat)
              .getBlockExpr())
    }

    /**
     * Holds if `getBlockExpr()` exists.
     */
    final predicate hasBlockExpr() { exists(this.getBlockExpr()) }

    /**
     * Holds if this const block pat is const.
     */
    predicate isConst() { Synth::convertConstBlockPatToRaw(this).(Raw::ConstBlockPat).isConst() }
  }
}
