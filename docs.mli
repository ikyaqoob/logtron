type StatsdClient : Object
type KafkaClient : Object

type Logger := EventEmitter & {
    trace: (String, Object, cb?: Callback) => void,
    debug: (String, Object, cb?: Callback) => void,
    info: (String, Object, cb?: Callback) => void,
    access?: (String, Object, cb?: Callback) => void,
    warn: (String, Object, cb?: Callback) => void,
    error: (String, Object, cb?: Callback) => void,
    fatal: (String, Object, cb?: Callback) => void,
    instrument: (server?: HttpServer, opts?: Object) => void,
    destroy: () => void
}

type BackendName := String
type LevelName := String

type Backend := {
    createStream: (meta: Object) => {
        write: ([
            levelName: String,
            message: String,
            meta: Object
        ], Callback) => void,
        end: () => void,
        destroy?: () => void
    }
}

type LoggerOpts := {
    meta: {
        team: String,
        project: String,
        hostname: String,
        pid: Number
    },
    backends: Object<BackendName, Backend>,
    filters?: Array<Function>,
    transforms?: Array<Function>,
    levels?: Object<LevelName, {
        backends: Array<BackendName>,
        filters?: Array<Function>,
        transforms?: Array<Function>,
        level: Number
    }>
}

rt-logger/backends/disk := ({
    folder: String
}) => Backend

rt-logger/backends/kafka := ({
    leafHost?: String,
    leafPort?: Number,
    properties?: Object,
    statsd?: Object
}) => Backend

rt-logger/backends/console := () => Backend

rt-logger/backends/sentry := ({
    dsn: String,
    defaultTags?: Object,
    statsd?: Object
}) => Backend

rt-logger/logger := (LoggerOpts) => Logger & {
    defaultBackends: (config: {
        logFolder?: String,
        kafka?: {
            leafHost: String,
            leafPort: Number
        },
        console?: Boolean,
        sentry?: {
            id: String
        }
    }, clients?: {
        statsd: StatsdClient,
        kafkaClient?: KafkaClient
    }) => {
        disk: Backend | null,
        kafka: Backend | null,
        console: Backend | null,
        sentry: Backend | null
    }
}
