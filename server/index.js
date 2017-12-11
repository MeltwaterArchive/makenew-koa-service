import boot from './boot'

if (require.main === module) {
  const { configFactory, run } = boot()
  run(configFactory)
}
