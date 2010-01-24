// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function generateHealthTooltips()
{
  $j('.health-column').each(function()
  {
    $j(this).qtip(
    {
      content: {text: 'Loading...',
                url: '/cmdb/computers/' + $j(this).children('img').attr('alt') + '/health',
                prerender: true},
      position: {corner: {target: 'bottomLeft', tooltip: 'topLeft'},  adjust: {x: 35}},
      style: {name: 'light', width: 400,
              'font-size': 12, 'font-weight': 'normal', 'text-align': 'center'},
      show: {solo: true, delay: 75, effect: {length: 75}},
      hide: {fixed: true, delay: 250, effect: {length: 75}}
    });
  });
  $j('#as_computers-content th, span.truncate-with-tip').each(function()
  {
    if($j(this).attr('title')) {
      $j(this).qtip(
        {
          content: {text: $j(this).attr('title')},
          position: {corner: {target: 'topLeft', tooltip: 'bottomLeft'}, adjust: {x: 20}},
          style: {name: 'blue', tip: 'bottomLeft'}
        });
      $j(this).attr(
        {
          title: ""
        });
      };
  });
}

$j(document).ready(function()
{
  generateHealthTooltips()
});