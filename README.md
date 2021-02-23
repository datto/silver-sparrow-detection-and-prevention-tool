# Datto Silver Sparrow Detection and Prevention Tool

## Summary

This script is an implementation of the excellent write-up by Red Canary, available here: https://redcanary.com/blog/clipping-silver-sparrows-wings/

The script performs a check for all files that could serve as an indication of local infection with known paths;
this means that the "updater" and "tasker" binaries mentioned and given file hashes are _not_ scanned for,
as their location cannot be collected reliably, even if running, due to shortcomings within macOS.

The script helps to detect the current variant and places the self-destruct file to help remove
the presence of Silver Sparrow, preventing a payload from being delivered.
The script is based on the indicators in the Red Canary report, which may evolve,
therefore community feedback is welcomed to support continuous improvement.

Each time a file is found that could serve as an indication of infection, a counter increments;
a score of three or above should be taken as a sure sign of infection.
This logic was implemented due to the generic names of many of the components.
A score of one or two should be scrutinized closely; it may be a false positive.

The script will place a file called `._insu` in the `~/Library` location.
This zero-byte file is recognised by Red Canary as being a sufficient trigger
to cause the Silver Sparrow infection to clean itself off the endpoint.

## Acknowledgements

The location `~` is an alias that redirects to the location in `/Users` for the current user.
Since the script was designed to be run as root, this alias cannot be used, and as such
a surrogate routine runs to intellect the logged-in user and map it to the variable `$varUser`.

`~`, therefore, becomes `/Users/$varUser`. It is unclear at this point whether this file needs
to be present in the `~` directories for all users of a macOS device or if one is sufficient.

In the event of a detection, a file is made in the same directory as the script called
`detection.txt` (case sensitive). You can monitor for the presence of this file to gather
whether a system has reported an infection.

## Credits

Script written by seagull for Datto RMM, first release 22nd February 2021.

It has been released to the community as part of Datto's commitment to the MSP.

You may edit, re-use and re-distribute the code per the license terms in LICENSE,
but please preserve the opening code comments verbatim, adding your own as necessary.

Datto RMM: https://www.datto.com/rmm


