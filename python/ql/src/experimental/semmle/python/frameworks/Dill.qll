/**
 * Provides classes modeling security-relevant aspects of the 'dill' package.
 * See https://pypi.org/project/dill/.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Dill {
  /** Gets a reference to the `dill` module. */
  private DataFlow::Node dill(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("dill")
    or
    exists(DataFlow::TypeTracker t2 | result = dill(t2).track(t2, t))
  }

  /** Gets a reference to the `dill` module. */
  DataFlow::Node dill() { result = dill(DataFlow::TypeTracker::end()) }

  /** Provides models for the `dill` module. */
  module dill {
    /** Gets a reference to the `dill.loads` function. */
    private DataFlow::Node loads(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("dill", "loads")
      or
      t.startInAttr("loads") and
      result = dill()
      or
      exists(DataFlow::TypeTracker t2 | result = loads(t2).track(t2, t))
    }

    /** Gets a reference to the `dill.loads` function. */
    DataFlow::Node loads() { result = loads(DataFlow::TypeTracker::end()) }
  }
}

/**
 * A call to `dill.loads`
 * See https://pypi.org/project/dill/ (which currently refers you
 * to https://docs.python.org/3/library/pickle.html#pickle.loads)
 */
private class DillLoadsCall extends Decoding::Range {
  DillLoadsCall() { this.asCfgNode().(CallNode).getFunction() = Dill::dill::loads().asCfgNode() }

  override predicate unsafe() { any() }

  override DataFlow::Node getAnInput() {
    result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
  }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() { result = "dill" }
}
