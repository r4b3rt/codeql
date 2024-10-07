use anyhow::Context;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
mod archive;
mod config;
pub mod generated;
mod rust_analyzer;
mod translate;
pub mod trap;

fn extract(
    rust_analyzer: &mut rust_analyzer::RustAnalyzer,
    traps: &trap::TrapFileProvider,
    file: std::path::PathBuf,
) -> anyhow::Result<()> {
    let (ast, input, parse_errors, file_id, semi) = rust_analyzer.parse(&file);
    let line_index = LineIndex::new(input.as_ref());
    let display_path = file.to_string_lossy();
    let mut trap = traps.create("source", &file);
    let label = trap.emit_file(&file);
    let mut translator = translate::Translator::new(
        trap,
        display_path.as_ref(),
        label,
        line_index,
        file_id,
        semi,
    );

    for err in parse_errors {
        translator.emit_parse_error(&err);
    }
    let no_location = (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 });
    if translator.semi.is_none() {
        translator.emit_diagnostic(
            trap::DiagnosticSeverity::Warning,
            "semantics".to_owned(),
            "semantic analyzer unavailable".to_owned(),
            "semantic analyzer unavailable: macro expansion, call graph, and type inference will be skipped.".to_owned(),
            no_location,
        );
    }
    translator.emit_source_file(ast);
    translator.trap.commit()?;
    Ok(())
}
fn main() -> anyhow::Result<()> {
    let cfg = config::Config::extract().context("failed to load configuration")?;
    stderrlog::new()
        .module(module_path!())
        .verbosity(2 + cfg.verbose as usize)
        .init()?;
    let mut rust_analyzer = rust_analyzer::RustAnalyzer::new(&cfg)?;

    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: cfg.source_archive_dir,
    };
    for file in cfg.inputs {
        let file = std::path::absolute(&file).unwrap_or(file);
        let file = std::fs::canonicalize(&file).unwrap_or(file);
        archiver.archive(&file);
        extract(&mut rust_analyzer, &traps, file)?;
    }

    Ok(())
}
