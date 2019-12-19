const Gulp = require("gulp")
const BrowserSync = require("browser-sync")
const ChildProcess = require("child_process")
const Del = require("del")
const Minimist = require("minimist")
const Path = require("path")
const Fs = require("fs")
const log = require("fancy-log")

const antoraCliPath = Path.resolve(Path.dirname(require.resolve('@antora/cli')), '..', 'bin', 'antora')

function throwOptionRequired(option) {
    throw new Error(`Option required: ${option}`);
}

function parseOptions(argv) {

    const knownOptions = {
        string: ['src', 'output', 'playbook', 'plantuml-server-url']
    };

    const options = Minimist(argv, knownOptions);

    const plantUmlServerUrl = options["plantuml-server-url"] || "http://www.plantuml.com/plantuml"

    const resultOpts = {
        srcDir: options.src ? Path.resolve(options.src) : undefined,
        outputDir: options.output ? Path.resolve(options.output) : undefined,
        plantUmlServerUrl: plantUmlServerUrl,
        playbookPath: options.playbook ? Path.resolve(options.playbook) : undefined,
        workDir: options.playbook ? Path.resolve(Path.dirname(options.playbook)) : undefined
    }

    return resultOpts
}

const options = parseOptions(process.argv.slice(2))
log.info("Build options is:", options)

function compile(cb) {

    const attrs = []

    if (options.plantUmlServerUrl) {
        attrs.push(`--attribute "plantuml-server-url=${options.plantUmlServerUrl}"`)
    }

    if (!options.playbookPath) {
        throwOptionRequired("--playbook <path/to/playbook.yml>")
    }

    if (!options.outputDir) {
        throwOptionRequired("--output <path/to/output>");
    }

    const joinedAttrs = attrs.join(" ")

    Fs.mkdirSync(options.outputDir, { recursive: true });

    const command = `
        "${antoraCliPath}" --stacktrace \
        ${joinedAttrs} \
        --to-dir "${options.outputDir}" \
        "${options.playbookPath}" 
        `

    ChildProcess.execSync(command, { cwd: options.workDir })

    cb()
}

function clean(cb) {
    if (!options.outputDir) {
        throwOptionRequired("--output <path/to/output>");
    }
    const removeGlob = Path.resolve(options.outputDir, "*")
    Del.sync([removeGlob], { force: true })
    cb()
}

const build = Gulp.series(clean, Gulp.parallel(compile))

function watch() {

    if (!options.srcDir) {
        throwOptionRequired("--src <path/to/watch>");
    }

    const browserSync = BrowserSync.create()

    browserSync.init({
        server: options.outputDir,
        open: false,
        notify: true,
    })

    const reload = cb => {
        browserSync.reload()
        cb()
    }

    const notify = cb => {
        log.info("Compiling, please wait...")
        browserSync.notify("Compiling, please wait...", 10000)
        cb()
    }

    const watchingFilesGlob = Path.resolve(options.srcDir, "**")

    log.info(`Watch for files in: ${watchingFilesGlob}`)

    Gulp.watch(
        [watchingFilesGlob],
        Gulp.series(notify, build, reload)
    )
}

exports.clean = clean
exports.build = build
exports.watch = Gulp.series(build, watch)
exports.default = build
