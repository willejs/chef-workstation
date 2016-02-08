# workstation

This cookbook configures and installs all software needed on my workstation. I made it because I got a new laptop, and im lazy and dont want to have to click through a bunch of dialogue boxes, but also wanted to try out chef policies. 

## How To

#### Install chefdk
[Download Page](https://downloads.chef.io/chef-dk/mac/)

#### Build your policyfile lockfile
Vendor all of your dependent cookbooks

```chef update```

#### Export the policy file
This will create a client.rb for chef zero too

```chef export Policyfile.rb ./.vendor```

#### Run chef!

```cd .vendor && sudo chef-client -z -c ./client.rb; cd ..```

### Run Tests

Run testkitchen

```kitchen verify```
