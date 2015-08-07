#Language: Spanish
module.exports = de =

  appName: 'Protothril'

  registration:
    email:
      confirmation:
        title: "@{appName}: Konto aktivieren"
        html: "Mit diesem <a href='http://@{host}/confirmRegistration/@{email}/@{token}'>Link</a> bestätigen die E-Mail Adresse für @{appName}."
    confirmation:
      html: """
        <h1>Danke für Ihre erfolgreiche Registrierung.</h1>
        <p>Sie erhalten nun eine E-Mail mit deren Hilfe Sie Ihren Zugang freischalten können.</p>
        <p>1. Bitte rufen Sie Ihre E-Mail ab.</p>
        <p>2. Bitte öffnen Sie die E-Mail mit dem Betreff: "Bitte aktivieren Sie Ihr Benutzerkonto bei @{appName}"</p>
        <p>Sollten Sie diese E-Mail nicht in Ihrem Posteingang finden, prüfen Sie bitte, ob die E-Mail versehentlich in den Spam-Ordner sortiert wurde.</p>
        <p>Klicken Sie bitte den in der E-Mail enthaltenen Link, um Ihre Registrierung bzw. Aktualisierung abzuschließen.</p>
        """ 