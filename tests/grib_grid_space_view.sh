#!/bin/sh
# (C) Copyright 2005- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# 
# In applying this licence, ECMWF does not waive the privileges and immunities granted to it by
# virtue of its status as an intergovernmental organisation nor does it submit to any jurisdiction.

. ./include.sh

# Define a common label for all the tmp files
label="grib_space_view_test"
tempFilter="temp.${label}.filt"
tempGrib="temp.${label}.grib"
tempOut="temp.${label}.out"

# -----------
# GRIB2
# -----------
input=$ECCODES_SAMPLES_PATH/GRIB2.tmpl
cat > $tempFilter <<EOF
 set gridType="space_view";
 set Nx=1900;
 set Ny=900;
 set dx=3622;
 set dy=3610;
 set Xp=764000;
 set Yp=1774000;
 set Nr=6610700;
 set numberOfDataPoints=1710000;  # 1900 x 900
 set numberOfValues=1710000;
 write;
EOF

# Use filter on input to create a new GRIB
${tools_dir}/grib_filter -o $tempGrib $tempFilter $input
if [ ! -f "$tempGrib" ]; then
   echo 'Failed to create output GRIB from filter' >&2
   exit 1
fi
# Invoke Geoiterator on the newly created GRIB file
${tools_dir}/grib_get_data $tempGrib > $tempOut

${tools_dir}/grib_ls -l 50,0 $tempGrib

# -----------
# GRIB1
# -----------
input=$ECCODES_SAMPLES_PATH/GRIB1.tmpl
cat > $tempFilter <<EOF
 set gridType="space_view";
 set Nx=550;
 set Ny=550;
 set dx=54;
 set dy=54;
 set XpInGridLengths=2750;
 set YpInGridLengths=2750;
 set NrInRadiusOfEarth=6610710;
 write;
EOF
${tools_dir}/grib_filter -o $tempGrib $tempFilter $input
${tools_dir}/grib_get_data $tempGrib > $tempOut


# Clean up
rm -f $tempFilter $tempGrib $tempOut
