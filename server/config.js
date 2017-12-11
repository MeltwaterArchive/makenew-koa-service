import path from 'path'

export default (
  configFactory,
  /* istanbul ignore next */
  root = '../'
) => {
  const dataPath = path.resolve(__dirname, root, 'data')

  configFactory.addOverride({
    data: {
      path: dataPath
    }
  })

  configFactory.addOverride({
    koa: {
      favicon: {
        path: path.resolve(dataPath, 'favicon.ico')
      }
    }
  })
}
