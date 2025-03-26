// Entry point for the build script in your package.json

import "htmx.org";

setTimeout(function () {
    var noticeElement = document.getElementById('notice');
    if (noticeElement) {
      noticeElement.style.opacity = '0';
      setTimeout(function () {
        noticeElement.style.display = 'none';
      }, 500);
    }
  }, 3000);

  setTimeout(function () {
    let alertElement = document.getElementById("alert");
    if (alertElement) {
      alertElement.style.opacity = "0";
      setTimeout(function () {
        alertElement.style.display = "none";
      }, 500);
    }
  }, 3000);
