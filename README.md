The [Lunar Orbiter Image Recovery Project (LORIP)][1] recovered and restored the images taken by the 5 Lunar Orbiter satellites that NASA sent in 1966 and 1967 to plan the moon landings.
The recovery effort is [an impressive story][2].
I first heard about it [here][3].

The digital artifacts that LORIP created are [now housed at the JPL][4].
In their holdings there are [PNG files created from the original, lossless images][5].
Unfortunately there isn't an easy way to browse them.

There are about 3000 photos in the archive from the 5 missions.
Combined, the PNG derivatives weigh in at just under 18Gb.

This project contains the scripts I used to explore the collection myself.
I'm not a lunar scientist; I'm only looking for pretty pictures.
My favorites are:

- [FRAME_1027_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1027/FRAME_1027_M.PNG)
- [FRAME_1038_H2.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1038/FRAME_1038_H2.PNG)
- [FRAME_1084_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1084/FRAME_1084_M.PNG)
- [FRAME_1102_H2.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1102/FRAME_1102_H2.PNG) (earthrise)
- [FRAME_1114_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1114/FRAME_1114_M.PNG)
- [FRAME_1115_H1.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1115/FRAME_1115_H1.PNG)
- [FRAME_1116_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO1/FRAME_1116/FRAME_1116_M.PNG)
- [FRAME_4006_H2.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO4/FRAME_4006/FRAME_4006_H2.PNG)
- [FRAME_5006_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5006/FRAME_5006_M.PNG)
- [FRAME_5019_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5019/FRAME_5019_M.PNG)
- [FRAME_5081_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5081/FRAME_5081_M.PNG)
- [FRAME_5085_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5085/FRAME_5085_M.PNG)
- [FRAME_5124_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5124/FRAME_5124_M.PNG)
- [FRAME_5127_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5127/FRAME_5127_M.PNG)
- [FRAME_5135_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5135/FRAME_5135_M.PNG)
- [FRAME_5151_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5151/FRAME_5151_M.PNG)
- [FRAME_5201_M.PNG](https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/LO5/FRAME_5201/FRAME_5201_M.PNG)

## Using the Tool

Because this is a Ruby script you'll need to [install Ruby][6] (see `.ruby_version` for the required version) and [`bundler`][7]

`crawl.rb` generates two files:

1. `structure.json` is an intermediate representation of the site structure; it speeds up processing
2. `image_urls.txt` is a list of absolute URLs for the PNGs

One way to download all the images is to use `wget`

```
wget -i image_urls.txt
```

[1]: http://www.moonviews.com/
[2]: https://www.wired.com/2014/04/lost-lunar-photos-recovered-by-great-feats-of-hackerdom-developed-at-a-mcdonalds/
[3]: http://www.worldofindie.co.uk/?p=682
[4]: https://pds-imaging.jpl.nasa.gov/volumes/loirp.html
[5]: https://pds-imaging.jpl.nasa.gov/data/lo/LO_1001/EXTRAS/BROWSE/
[6]: http://www.ruby-lang.org/en/downloads/
[7]: https://bundler.io/
