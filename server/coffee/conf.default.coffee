module.exports =
  appName: 'protothril'
  debugPort: 3017
  elasticsearch:
    host: 'localhost:9200'
    index: 'users'
  smtp:
    host: 'localhost'
    secure: true
    auth:
      user: 'protothril@localhost'
      pass: 'secret'
  appEmail: 'protothril@localhost'
  frontend: 'localhost:9000/?'
