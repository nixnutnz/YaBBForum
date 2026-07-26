//##############################################################################
//# MessageIndex.js                                                            #
//##############################################################################
//# YaBB: Yet another Bulletin Board                                           #
//# Open-Source Community Software for Webmasters                              #
//# Version:        YaBB 2.6.14                                                #
//# Packaged:       July 26, 2026                                            #
//# Distributed by: http://yabbforum.nz                                   #
//# ===========================================================================#
//# Copyright (c) 2000-2016 YaBB (yabbforum.nz) - All Rights Reserved.    #
//# Software by:  The YaBB Development Team                                    #
//#               with assistance from the YaBB community.                     #
//##############################################################################

//YaBB 2.6.14 $Revision: 1611 $

function checkAll(j) {
    for (var i = 0; i < document.multiadmin.elements.length; i++) {
        if (document.multiadmin.elements[i].type == "checkbox" && !/all\$/.test(document.multiadmin.elements[i].name) && (j === 0 || (j !== 0 && (i % $modul) == (j - 1))))
            document.multiadmin.elements[i].checked = true;
    }
}

function checkAll2(j, name) {
    var multi = document.getElementById("multiadmin"+name);
    for (var i = 0; i < multi.elements.length; i++) {
        if (multi.elements[i].type == "checkbox" && !/all\$/.test(multi.elements[i].name) && (j === 0 || (j !== 0 && (i % $modul) == (j - 1))))
            multi.elements[i].checked = true;
    }
}

function uncheckAll(j) {
    for (var i = 0; i < document.multiadmin.elements.length; i++) {
        if (document.multiadmin.elements[i].type == "checkbox" && !/all\$/.test(document.multiadmin.elements[i].name) && (j === 0 || (j !== 0 && (i % $modul) == (j - 1))))
            document.multiadmin.elements[i].checked = false;
    }
}

function uncheckAll2(j, name) {
    var multi = document.getElementById("multiadmin"+name);
    for (var i = 0; i < multi.elements.length; i++) {
        if (multi.elements[i].type == "checkbox" && !/all\$/.test(multi.elements[i].name) && (j === 0 || (j !== 0 && (i % $modul) == (j - 1))))
            multi.elements[i].checked = false;
    }
}

function checkaction(s) {
    if (s.options[s.selectedIndex].value == "move") {
        document.getElementById("moveoptions").style.display = "inline-block";
    } else {
        document.getElementById("moveoptions").style.display = "none";
    }
}