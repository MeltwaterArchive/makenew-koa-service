import path from 'path'

import createExamples from '@meltwater/examplr'
import createLogger from '@meltwater/mlabs-logger'

import boot from '../server/boot'
import health from './health'

export const examples = {
  health
}

const envVars = [
  'KOA_API',
  'LOG_LEVEL',
  'LOG_OUTPUT_MODE'
]

const defaultOptions = {}

const serverOptions = config => {
  const host = 'http://localhost'
  const port = config.get('port')

  return {
    koaApi: port ? `${host}:${port}` : host
  }
}

if (require.main === module) {
  boot((run, configFactory, callback) => {
    try {
      configFactory.create((err, config) => {
        try {
          if (err) throw err

          const { runExample } = createExamples({
            createLogger,
            examples,
            envVars,
            defaultOptions: {...defaultOptions, ...serverOptions(config)}
          })

          runExample({
            local: path.resolve(__dirname, 'local.json')
          })
          callback()
        } catch (err) {
          callback(err)
        }
      })
    } catch (err) {
      callback(err)
    }
  })
}
