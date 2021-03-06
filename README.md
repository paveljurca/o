# Light web frontend to YouTube playlists

Works with any video service that supports video embedding. See the `video.tt.html` template and a JSON data file, specifically those `playlist_url` and `playlist_id` keys.

__USECASE:__

[Recordings of school lectures](https://www.youtube.com/channel/UCEQZNCGGr2SgUb3LNp0-qaA/playlists) put on YouTube
miss some additional data, ordering, search or proper representation. This is not suitable to students
nor a teacher when it comes to views.

With a single JSON file and a few thumbnails we can improve that experience.
*Better experience* to me means *more approachable* lectures and that means more students who are going to watch them.

![PRINTSCREEN](printscreen/1.png "Oikumena.cz")

## SYNOPSIS

`./build.sh DESTINATION_FOLDER`

## RELEASE NOTES

* For sort to work, school terms should be in the following format `\w{2} \d{4}/\d{2}`, i.e. "LS 2015/16"
* If present, filenames for the video html files are taken from the relevant **CODE** key
* Using a JSON document-like model it is eventually easy to group by any key

(+) Depends only on core modules
(-) Uses my very own template engine :))

## TODO

- [x] Template UTF-8 support

  The error: _"Reading from in-memory file handle: *Strings with code points over 0xFF may not be mapped into in-memory file handles."_


*(Idea)* Make final ZIP file one can easily deploy on any web server

#### COMMIT LOG

    [..]

    commit 59be89aa0f66463c32a91feb1dd277c8587f9cae
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Sun Feb 19 22:23:35 2017 +0100

        adjusted cover; working on templates

    commit f18b93087b36cbc6abfb9f7ddd84cb9dc961b12a
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Thu Nov 3 12:03:34 2016 +0100

        adjustments for the forthcoming update: bootstrap, isotope, data in json, perl

    commit c26484a10be542bb89e313746133eb11e6d54568
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Thu Oct 27 18:45:38 2016 +0200

        there'll be a single json file providing the up-to-date YT playlists, URLs and info

    commit 22c4f0792aa83ecaa03d8bb6e6a6c4eb0439ab4c
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Thu Oct 27 12:45:45 2016 +0200

        google-site-verification meta tag

    commit 102bf6dfb7ac1a7f6d93c1f65c2e66227679b383
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Sat Oct 22 17:40:09 2016 +0200

        added fb opengraph tags, added ico.png, updated youtube skeleton

    commit a6942aac76e85e9a94728b23bf56e70dd6b9fa17
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Sat Oct 22 13:51:21 2016 +0200

        redirection to YouTube

    commit d973ce37a64fa9fdf0f687456da0a5bdd8403cc1
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Fri Oct 21 21:48:56 2016 +0200

        new skeleton for MP3 and modified <head> of index.html

    commit 17b59ec17ce2862f0ee6ef11f5fa30bcd7291eae
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Fri Oct 21 19:08:15 2016 +0200

        adding the &start param

    commit b823d6ae02875ef1b49c966d9276ecc3801418ff
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Fri Oct 21 18:17:21 2016 +0200

        adjustments of the youtube iframe

    commit 1fb72a24c4df042a0db95f34b1125d4de24336c8
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Thu Oct 20 13:41:11 2016 +0200

        source file URIs

    commit bd579bd614413d7f826eae0526d9a044ea25e6f9
    Author: Pavel Jurča <paveljurca@users.noreply.github.com>
    Date:   Thu Oct 20 13:13:24 2016 +0200

        custom 404, youtube embed skeleton


    [..]

## LICENSE 

Isotope is distributed under the GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html.

Released into the public domain.

## DISCLAIMER

Don't blame me.
