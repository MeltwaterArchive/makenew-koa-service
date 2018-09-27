import { URL } from 'url'

import { httpGetJson } from '@meltwater/mlabs-koa'

export default ({ log, koaApi }) => async (check = '') => {
  const url = new URL(`${koaApi}/health/${check}`)
  const { healthy, error } = await httpGetJson({
    hostname: url.hostname,
    path: url.path,
    port: url.port,
    headers: { accept: 'application/json' }
  })
  if (error) throw new Error(error)
  return healthy
}
