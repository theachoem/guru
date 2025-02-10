## 1. Git & GitHub

## 2. Payment Demo

This project is a minimal web with ruby sinatra (not rails). To run, just make sure you have install ruby (most mac already have ruby).

```
(cd payment/aba_ruby && bundle install)
```

Then start project with:
```
ruby payment/aba_ruby/app.rb
```

Flow: for payment to work, for most project, you only need two URLs (same as this demo project):
- /checkout -> to generate ABA form with transaction params
- /success -> aba redirect to this url after user pay from ABA.

Check [payment/aba_ruby/app.rb](payment/aba_ruby/app.rb) to see how these 2 URL work.

Demo:

https://github.com/user-attachments/assets/def22b5d-5cc5-492a-81c4-9de8f7c3390a
