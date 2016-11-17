#!/bin/env node
"use strict"

var _ = require('underscore')
  , url = require('url')
  , http = require('http')
  , https = require('https')
  , fs = require('fs')
  , moment = require('moment')
  , req = require('request')
  , async_lib = require('async')
  , argv = require('yargs')
      .option('o', {
        alias: 'opt'
        , demand: false
        , default: 'info'
        , describe: 'operation, [info]'
        , type: 'string'
      })
      .usage('Usage: ./index.js [options]')
      .example('./index.js -o info', 'restart the server')
      .help('h')
      .alias('h', 'help')
      .argv
  ;

var f = argv._[0];

fs.readFile(f
  , function(err,data){
    if (err) {
      console.error('Fail to read text file' + err);
      return;
    }
    var d = null
      ;

    d = JSON.parse(data);

    _.each(
      d.data, function(e){
        console.log(moment(e[0]).format('YYYY-MM-DD'),e[1],e[2],e[3],e[4],e[5],e[6]);
    });
  }
);

