import path from 'path'

import { config, createDependencies, createServer } from '../index.js'

export default () => {
  const root = path.basename(path.resolve(__dirname, '../')) === 'dist'
    /* istanbul ignore next */
    ? '../../'
    : '../'
  const configPath = path.resolve(__dirname, root, 'config')
  const { configFactory, run } = createServer({configPath, createDependencies})
  config(configFactory, root)
  return { configFactory, run }
}
