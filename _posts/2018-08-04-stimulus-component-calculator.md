---
title: "Stimulus component: Calculator for input fields"
tags:
  - rails
  - sitemap
  - git
---

Here's a small stimulusjs component at I wrote for budgetfuchs.

It calulates the value of an input with basic arithmetic like 2 + 10/3
and shows the result in the `result` target.

When leaving the input or submitting the form, the input's value is
replaced with the calculated value.:w

If the `result` target is set its `innerText` will be replace with the
value while the user is typing numbers and restored on leaving the input.

```html
<div data-controller="input-calculator">
  <label for="amount" data-target="input-calculator.result">Amount</label>
  <input name="amount" data-action="keydown->input-calculator#calculate keyup->input-calculator#calculate blur->input-calculator#calculate" />
</div>
```

The data-action has three event listeners simply because stimulus is opinionated about
what events to listen to. We need more to update the result on key-strokes (keyup)
and update it when the users hits enter to submit the form (keydown)

```coffeescript
import { Controller } from "stimulus"

export default class extends Controller
  @targets: ['result']

  connect: ->
    if @resultTarget && @resultTarget.dataset
      @flipResult = true
      @resultTarget.dataset['oldInnerHTML'] = @resultTarget.innerHTML

  calculate: (event) ->
    val = event.target.value
    if @flipResult
      @resultTarget.innerHTML = @resultTarget.dataset['oldInnerHTML']
    if val.match(/[+\-\*\/]/)
      try
        val = eval(val)
        if event.type == 'blur' || event.code == "Enter" || event.keyCode == 13 || event.which == 13
          event.target.value = val
        else if @flipResult
          @resultTarget.innerText = val
```

The code if of course MIT licensed.
