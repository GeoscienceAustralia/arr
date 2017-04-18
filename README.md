# Australian Rainfall and Runoff Document Source

This repository contains the complete source code required to build the current edition of Australian Rainfall and Runoff.  The supported formats you can build from here include:

* EPUB
* HTML

If you don't want to build the document yourself from source it can be downloaded for free from the [ARR Website](http://www.arr.org.au).

## Getting Started
### Introduction

The source for ARR is in XML documents using the DocBook V5 schema.  EXtensible Stylesheet Language (XSL) stylesheets are used to Transform (XSLT) the source XML into the desired output.  The majority of this process is transparent to the end user as it is quite rare to touch the sylesheets, with most of the work undertaken in the source XML themselves.

### Prerequisites

TODO: add the pre-requisite instructions.

### Build From Source

The general build process is:

```bash
cd arr
chmod +x build_make_includes
./build_make_includes
make clean
make epub
```

## Contributing

TODO: need to define the contribution process.

## Authors

Too many people have contributed directly to this project to list in this README.  Please see the individual books and chapters as well as the [ARR website](http://www.arr.org.au/) for direct authors and project teams.

## License

The Australian Rainfall and Runoff: A guide to flood estimation (ARR) is licensed under the Creative Commons Attribution 4.0 Licence, unless otherwise indicated or marked.

Please give attribution to: © Commonwealth of Australia (Geoscience Australia) 2015.

### Third Party Material

The Commonwealth of Australia and the ARR’s contributing authors (through Engineers Australia) have taken steps to both identify third-party material and secure permission for its reproduction and reuse. However, please note that where these materials are not licensed under a Creative Commons licence or similar terms of use, you should obtain permission from the relevant third-party to reuse their material beyond the ways you are legally permitted to use them under the fair dealing provisions of the [Copyright Act 1968](http://www.comlaw.gov.au/Details/C2014C00291).

### Further License Questions

For further information about the copyright in this document, please contact:

Intellectual Property and Copyright Manager  
Corporate Branch  
Geoscience Australia  
GPO Box 378  
CANBERRA ACT 2601  
Phone: +61 2 6249 9367 or email: copyright@ga.gov.au


ISBN 978-1-925297-07-2

How to reference this book:
Ball J, Babister M, Nathan R, Weeks W, Weinmann E, Retallick M, Testoni I, (Editors),  2016, Australian Rainfall and Runoff: A Guide to Flood Estimation, Commonwealth of Australia

## Acknowledgments
A pointless change for demonstration purposes
