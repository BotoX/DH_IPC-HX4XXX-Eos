var isIE = navigator.appName.indexOf("Microsoft") != -1;

function onloadsuccess() {
    var curDevice = window.location.search.split('='),
        arr = ['help_wifi', 'help_camera', 'help_3g', 'help_ad\\$ldap'],
        $t = null;
    $.each(arr, function (index, val) {
        $t = $('#' + val);
        if ($t.length > 0) {
            ((curDevice[1] || '').indexOf('2') !== -1) ? $t.hide() : $t.show();
        }
    });
}

function addSeachParams() {
    var search = window.location.search,
        $t = null,
        href = null;
    if (search) {
        $('a').each(function (index, el) {
            $t = $(el);
            href = $t.attr('href');
            if (href && href != 'javascript:;') {
                $t.attr('href', href + search);
            }
        });
    }
}

function back() {
    var search = window.location.search || '',
        url = window.location.href.split('/help')[0];
    if (window.location.href.indexOf('SimpChinese') !== -1) {
        location.href = url + '/help/SimpChinese/help.htm' + search + '';
    } else {
        location.href = url + '/help/English/help.htm' + search + '';
    }
}

function previewHelp() {
    var curDevice = window.location.search.split('='),
        arr = ['help_preview_remark', 'help_preview_gesture', 'help_preview_ptz', 'help_preview_ivs',
            'help_preview_focus', 'help_preview_easyfocus', 'help_preview_image', 'focusZoomSet'
        ],
        $t = null;
    $.each(arr, function (index, val) {
        $t = $('#' + val);
        if ($t.length > 0) {
            if ((curDevice[1] || '').indexOf('2') !== -1) {
                (index < 4) ? $t.show() : $t.hide();
            } else {
                (index < 4) ? $t.hide() : $t.show();
            }
        }
    });
}

function alarmSetHelp() {
    var curDevice = window.location.search.split('='),
        arr = ['flash_Set_title', 'flash_Set'],
        $t = null;
    $.each(arr, function (index, val) {
        $t = $('#' + val);
        if ($t.length > 0) {
            ((curDevice[1] || '').indexOf('2') !== -1) ? $t.hide() : $t.show();
        }
    });
}

function audioSetHelp() {
    var curDevice = window.location.search.split('=');
    if ((curDevice[1] || '').indexOf('2') !== -1) {
        $('#audio_helpFrequencyShow, #audio_helpmanagerShow').hide();
    }
}

function encodeHelp() {
    var curDevice = window.location.search.split('='),
        $t = $('#encode_720pshow');
    if ($t.length > 0) {
        ((curDevice[1] || '').indexOf('2') !== -1) ? $t.hide() : $t.show();
    }
}

function ptzHelp() {
    var curDevice = window.location.search.split('='),
        arr = ['help_ptz_move', 'help_ptz_pan'],
        $t = null;
    $.each(arr, function (index, val) {
        $t = $('#' + val);
        if ($t.length > 0) {
            ((curDevice[1] || '').indexOf('2') !== -1) ? $t.show() : $t.hide();
        }
    });
    $t = $('#joystick');
    if (($t.length > 0) && ((curDevice[1] || '').indexOf('2') === -1)) $t.hide();
}

function videoDetectHelp() {
    var curDevice = window.location.search.split('='),
        arr = ['videoSpe1', 'videoSpe2', 'videoSpe3', 'videoSpe4'],
        $t = null;
    $.each(arr, function (index, val) {
        $t = $('#' + val);
        if ($t.length > 0) {
            ((curDevice[1] || '').indexOf('2') !== -1) ? $t.hide() : $t.show();
        }
    });
}

function cameraConfigHelp() {
    var curDevice = window.location.search.split('=');
    if ((curDevice[1] || '').indexOf('s') !== -1) $('.multiple').hide();
    if ((curDevice[1] || '').indexOf('2') === -1) $('.typeSD').hide();
    if ((curDevice[1] || '').indexOf('t') === -1) $('.notTemp').hide();
}

$(window).ready(function () {
    addSeachParams();
});