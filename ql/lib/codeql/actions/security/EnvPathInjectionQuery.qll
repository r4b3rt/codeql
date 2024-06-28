private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.dataflow.FlowSteps
import codeql.actions.DataFlow
import codeql.actions.dataflow.FlowSources

abstract class EnvPathInjectionSink extends DataFlow::Node { }

/**
 * Holds if a Run step declares a PATH environment variable with contents from a local file.
 * e.g.
 *    run: |
 *      cat foo.txt >> $GITHUB_PATH
 */
class EnvPathInjectionFromFileReadSink extends EnvPathInjectionSink {
  EnvPathInjectionFromFileReadSink() {
    exists(Run run, UntrustedArtifactDownloadStep step, string value |
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      writeToGitHubPath(run, value) and
      outputsPartialFileContent(value)
    )
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare a PATH env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "$BODY" >> $GITHUB_PATH
 */
class EnvPathInjectionFromEnvVarSink extends EnvPathInjectionSink {
  EnvPathInjectionFromEnvVarSink() {
    exists(Run run, string var_name |
      envToRunFlow("GITHUB_PATH", var_name, run, _) and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr()
    )
  }
}

class EnvPathInjectionFromMaDSink extends EnvPathInjectionSink {
  EnvPathInjectionFromMaDSink() { externallyDefinedSink(this, "envpath-injection") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module EnvPathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvPathInjectionSink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate the PATH environment variable. */
module EnvPathInjectionFlow = TaintTracking::Global<EnvPathInjectionConfig>;
