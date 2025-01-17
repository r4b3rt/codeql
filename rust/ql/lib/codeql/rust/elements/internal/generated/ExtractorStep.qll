// generated by codegen, do not edit
/**
 * This module provides the generated definition of `ExtractorStep`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.internal.ElementImpl::Impl as ElementImpl
import codeql.files.FileSystem

/**
 * INTERNAL: This module contains the fully generated definition of `ExtractorStep` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * INTERNAL: Do not reference the `Generated::ExtractorStep` class directly.
   * Use the subclass `ExtractorStep`, where the following predicates are available.
   */
  class ExtractorStep extends Synth::TExtractorStep, ElementImpl::Element {
    override string getAPrimaryQlClass() { result = "ExtractorStep" }

    /**
     * Gets the action of this extractor step.
     */
    string getAction() {
      result = Synth::convertExtractorStepToRaw(this).(Raw::ExtractorStep).getAction()
    }

    /**
     * Gets the file of this extractor step, if it exists.
     */
    File getFile() {
      result = Synth::convertExtractorStepToRaw(this).(Raw::ExtractorStep).getFile()
    }

    /**
     * Holds if `getFile()` exists.
     */
    final predicate hasFile() { exists(this.getFile()) }

    /**
     * Gets the duration ms of this extractor step.
     */
    int getDurationMs() {
      result = Synth::convertExtractorStepToRaw(this).(Raw::ExtractorStep).getDurationMs()
    }
  }
}
