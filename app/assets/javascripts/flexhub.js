$(document).ready(function ($) {
  $("[data-href]").click(function () {
    window.location = $(this).data("href");
  });
});
