import path from 'path'

import { config, createDependencies, createServer } from '../index.js'

const defaultExec = (run, configFactory, callback) => {
  run(configFactory)
  callback()
}

export default (exec = defaultExec) => {
  try {
    const root = path.basename(path.resolve(__dirname, '../')) === 'dist'
    /* istanbul ignore next */
      ? '../../'
      : '../'
    const configPath = path.resolve(__dirname, root, 'config')

    const { configFactory, run, exit } = createServer({
      configPath,
      createDependencies
    })

    config(configFactory, root)
      .then(() => new Promise((resolve, reject) => {
        exec(run, configFactory, err => {
          if (err) reject(err)
          resolve()
        })
      }))
      .catch(exit)
  } catch (err) {
    console.error(err)
    process.exit(3)
  }
}
