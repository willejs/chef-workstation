# workstation

This cookbook configures and installs all software needed on my workstation. I made it because I got a new laptop, and im lazy and dont want to have to click through a bunch of dialogue boxes, but also wanted to try out chef policies. 

How To:

Install chefdk

##### Build your policyfile lockfile
####### this vendors all of your dependent cookbooks
```chef update```

##### export the policy file and create yourself a client.rb for chef zero
```chef export Policyfile.rb ./.vendor```

##### run chef!

```cd .vendor && sudo chef-client -z -c ./client.rb; cd ..```
