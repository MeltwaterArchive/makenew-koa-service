import boot from './boot'

export { default as createServer } from '@meltwater/mlabs-koa'
export { createDependencies } from '../lib'
export { default as boot, loadConfig } from './boot'
export { default as config } from './config'

if (require.main === module) boot()
