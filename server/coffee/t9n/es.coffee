#Language: Spanish
module.exports = es =

  appName: 'Protothril'

  registration:
    email:
      confirmation:
        title: "Activar su cuenta con @{appName}"
        html: "Siguese este <a href='http://@{host}/confirmRegistration/@{email}/@{token}'>enlace</a> para empezar con @{appName}."
    confirmation:
      html: """
        <h1>Gracias por registrarse aqui.</h1>
        <p>Usted va a recibir un email para confirmar su cuenta en un instante.</p>
        <p>1. Por favor, lea su email con el titulo: "Activar su cuenta con @{appName}".</p>
        <p>2. En el email hay un enlace. Si lo sigue ya esta con nosotros.</p>
        <p>En caso de no recibir el email por favor revise su carpeta de Spam.</p>
        """ 