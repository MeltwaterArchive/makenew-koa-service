'use strict'

require('source-map-support').install()

const boot = require('./dist/server/boot').default

if (require.main === module) boot()
