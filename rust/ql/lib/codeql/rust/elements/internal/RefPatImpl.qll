/**
 * This module provides a hand-modifiable wrapper around the generated class `RefPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RefPat

/**
 * INTERNAL: This module contains the customizable definition of `RefPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference pattern. For example:
   * ```rust
   * match x {
   *     &mut Option::Some(y) => y,
   *     &Option::None => 0,
   * };
   * ```
   */
  class RefPat extends Generated::RefPat {
    override string toString() {
      exists(string mut |
        (if this.isMut() then mut = "mut " else mut = "") and
        result = "&" + mut + "..."
      )
    }
  }
}
