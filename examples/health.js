import { httpGetJson } from '@meltwater/mlabs-koa'

export default ({log, koaApi}) => async (check = '') => {
  const url = `${koaApi}/health/${check}`
  log.debug({url}, 'Health')
  const { healthy, error } = await httpGetJson(url)
  if (error) throw new Error(error)
  return healthy
}
