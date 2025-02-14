// generated by codegen, remove this comment if you wish to edit this file
/**
 * This module provides a hand-modifiable wrapper around the generated class `ConstBlockPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ConstBlockPat

/**
 * INTERNAL: This module contains the customizable definition of `ConstBlockPat` and should not
 * be referenced directly.
 */
module Impl {
  /**
   * A const block pattern. For example:
   * ```rust
   * match x {
   *     const { 1 + 2 + 3 } => "ok",
   *     _ => "fail",
   * };
   * ```
   */
  class ConstBlockPat extends Generated::ConstBlockPat { }
}
