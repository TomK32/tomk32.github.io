---
layout: post
title: "sftp server using nodejs to connect to an API"
date: "2017-07-16 11:26:52 +0200"
tags: nodejs sftp request api
---

It's a long time since I uttered the term FTP and it wasn't part of a joke.
But SFTP (SSH FTP) is of course a different beast, ssh giving it the security required
and it was designed from the ground up.
The confusion in the name is very like with Java and JavaScript.

Still, when you already have the nice REST API for your webservice and a customer
comes along asking for uploading files in a way they are used to, SFTP might be high on the list.
But rather than installing a server, have some cron job to process the new files at midnight
I came up with a nifty solution that excels expectations without giving
users an account on the server, not even a restricted one.

[Brady](http://www.uberbrady.com)'s [node-sftp-server](https://github.com/BriteVerify/node-sftp-server)
allowed me to write a simple sftp server that accepts files, but doesn't do any other operaetions like listing
uploaded files. Whenever an upload is completed it will start the second phase and upload the file to
my application's API using the [request](https://github.com/request/request) library.

```js
"use strict";

var fs = require('fs');
var path = require('path');
var request = require('request');
var SFTPServer = require("node-sftp-server");

// contains a json like this, and maybe more information to auth with the API
// {"myuser": {"password": "yerysecret"}}
var accounts = JSON.parse(fs.readFileSync('accounts.json'));

// generate your keys with
// openssl genpkey -algorithm RSA -out ssh_host_rsa_key -pkeyopt rsa_keygen_bits:2048
var srv = new SFTPServer({
  privateKeyFile: "ssh_host_rsa_key"
});

// change port if required. Don't forget to tell your firefall or AWS Security Group
srv.listen(8022);

srv.on("connect", function(auth) {
  if (auth.method !== 'password' || auth.password !== accounts[auth.username].password) {
    console.log("login attempt from " + auth.username);
    return auth.reject();
  }
  console.log("login success from " + auth.username);
  var username = auth.username;

  return auth.accept(function(session) {
    // Don't return anything on read operations
    session.on("readdir", function(path, responder) {
      return "";
    });
    session.on("readfile", function(path, writestream) {
      return ""; 
    });
    return session.on("writefile", function(filepath, readstream) {
      var something;
      var filename = path.basename(filepath);
      something = fs.createWriteStream(filename);
      readstream.on("end",function() {
        // upload to api
        var formData = {
          file: {
            value: fs.createReadStream(filename),
            options: { filename: path.basename(filename) }
          }
        };
        // You will need your own authentication here
        request.post({
            url: 'https://example.com/upload', formData: formData},
            function optionalCallback(err, httpResponse, body) {
              if (err) {
                return console.error('upload failed:', err);
              }
              console.log('Upload of ' + filename + ' successful!  Server responded with:', body);
        });
      });
      return readstream.pipe(something);
    });
  });
});

srv.on("error", function() {
  return console.warn("Example server encountered an error");
});
srv.on("end", function() {
  return console.warn("Example says user disconnected");
});

```
