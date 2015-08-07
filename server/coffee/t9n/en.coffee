#Language: Spanish
module.exports = de =

  appName: 'Protothril'

  registration:
    email:
      confirmation:
        title: "@{appName}: Activate account"
        html: "With this <a href='http://@{host}/confirmRegistration/@{email}/@{token}'>Link</a> you confirm your email and activate your account with @{appName}."
    confirmation:
      html: """
        <h1>Thank you for registering.</h1>
        <p>You will receive an email with a link to activate your account.</p>
        <p>1. Please open your email with the title: "Please activate your account with @{appName}".</p>
        <p>2. There is a link in the email. Just click on it and you can log in afterwards.</p>
        <p>If you have not received an email after some time please revise your spam folder.</p>
        """ 