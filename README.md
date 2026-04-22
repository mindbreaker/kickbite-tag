# Kickbite Tag for Google Tag Manager

Unofficial Google Tag Manager **custom template** that loads the
[Kickbite](https://www.kickbite.io/) tracking scripts and fires either a
**Page View** or a **Conversion** hit, without having to hard-code the
HTML snippet on every page.

Under the hood it simply injects:

```
https://tr.kickbite.io/u.js
https://tr.kickbite.io/script.js
```

...initialises `window.kbd` with your parameters and calls `kb()`.

## Setup

1. In Google Tag Manager open **Templates > New** and import `template.tpl`,
   or install it from the Community Template Gallery once published.
2. Create a new tag using the **Kickbite** template.
3. Pick the **Tracking Type**:
   - **Page View**: fires on every page.
   - **Conversion**: fires on the Thank-You page only.
4. Fill in the fields (see below) and attach the appropriate trigger.
5. Publish.

## Parameters

| Field | Required | Description |
|---|---|---|
| Tracking Type | yes | `Page View` or `Conversion` |
| Account ID (`aid`) | yes | Your Kickbite account identifier |
| Conversion ID (`conv_id`) | yes (Conversion only) | Order number from your shop system |
| Conversion Revenue (`conv_rev`) | no | Order total excluding VAT, e.g. `11.95` |

For the Conversion tag, map `conv_id` and `conv_rev` to Data Layer variables
from your shop system (e.g. `{{DLV - ecommerce.purchase.actionField.id}}` and
`{{DLV - ecommerce.purchase.actionField.revenue}}`).

## What it does

The template is equivalent to placing the following HTML on the page:

**Page View**
```html
<script src="https://tr.kickbite.io/u.js"></script>
<script src="https://tr.kickbite.io/script.js"></script>
<script>
  (function(w){
    w.kbd = w.kbd || {};
    w.kbd.aid = 'YOUR_AID';
    kb();
  })(window);
</script>
```

**Conversion**
```html
<script src="https://tr.kickbite.io/u.js"></script>
<script src="https://tr.kickbite.io/script.js"></script>
<script>
  (function(w){
    w.kbd = w.kbd || {};
    w.kbd.aid = 'YOUR_AID';
    w.kbd.conv_id = 'YOUR_ORDER_NUMBER';
    w.kbd.conv_rev = 'YOUR_ORDER_TOTAL_EX_VAT';
    kb();
  })(window);
</script>
```

The tag reports success after both scripts have loaded and `kb()` has been
called.

## Permissions

The template requests the following sandboxed permissions:

- `inject_script` for `https://tr.kickbite.io/u.js` and `https://tr.kickbite.io/script.js`
- `access_globals`
  - `kbd`: read and write
  - `kb`: execute
- `logging` in debug mode

## Disclaimer

This is an **unofficial** template. It is not affiliated with, endorsed by, or
supported by Kickbite. "Kickbite" is a trademark of its respective owner.

## License

[Apache 2.0](./LICENSE)
