import http from 'http'

const requestAsync = url => new Promise((resolve, reject) => {
  http.get(url, resp => {
    let data = ''
    resp.on('data', chunk => { data += chunk })
    resp.on('end', () => { resolve(JSON.parse(data)) })
  }).on('error', err => { reject(err) })
})

export default ({log, koaApi}) => async (check = '') => {
  const url = `${koaApi}/health/${check}`
  log.debug({url}, 'Health')
  const { healthy, error } = await requestAsync(url)
  if (error) throw new Error(error)
  return healthy
}
