//
//  add_xml_id_arr.c
//
//
//  Created by Peter Brady on 29/01/2015.
//
// To compile:
// gcc `xml2-config --cflags --libs` -o add_xml_id_arr add_xml_id_arr.c

/* This program is designed for the ARR DocBook XML to automatically insert
 * xml:id attributes for the following nodes:
 *  -) figures
 *  -) tables
 *  -) equations
 *  -) sections
 * But only if there is not an existing xml:id attribute in place.
 *
 * The code is pretty quick and dirty as I've simply cut and pasted sections of
 * code rather than properly handle the memory buffer when creating new nodes.
 * It does, however, appear to work.
 *
 * For how to use, look at the options.
 *
 * NOTA BENE: by default it will over write the requested XML input file.
 *
 * Peter Brady <peter.brady@wmawater.com.au>
 * 2015-01-29 */

#include "add_xml_id_arr.h"

xmlXPathObjectPtr
getnodeset (xmlDocPtr doc, xmlChar *xpath){
    
    xmlXPathContextPtr context;
    xmlXPathObjectPtr result;
    
    context = xmlXPathNewContext(doc);
    if (context == NULL) {
        printf("Error in xmlXPathNewContext\n");
        return NULL;
    }
    result = xmlXPathEvalExpression(xpath, context);
    xmlXPathFreeContext(context);
    if (result == NULL) {
        printf("Error in xmlXPathEvalExpression\n");
        return NULL;
    }
    if(xmlXPathNodeSetIsEmpty(result->nodesetval)){
        xmlXPathFreeObject(result);
        printf("No result\n");
        return NULL;
    }
    return result;
}



void genAlphaID(char *s, const int len) {
    /* function to generate alpha numeric ids
     * Adapted from: http://stackoverflow.com/questions/440133/how-do-i-create-a-random-alpha-numeric-string-in-c
     */
    static const char alphanum[] =
    "0123456789"
    "abcdefghijklmnopqrstuvwxyz";
    
    for (int i = 0; i < len; ++i) {
        s[i] = alphanum[rand() % (sizeof(alphanum) - 1)];
    }
    
    s[len] = 0;
}


// Main entry function:
int
main(int argc, char **argv) {
    
    char *docname;
    char *prefix;
    xmlDocPtr doc;
    xmlNodeSetPtr nodeset;
    xmlXPathObjectPtr result;
    xmlNodePtr cur;
    int i;
    xmlChar *keyword;
    xmlAttrPtr hasAttr;
    xmlNodePtr newnode;
    xmlAttrPtr newattr;
    
    char *idToInsert;
    char IDRand[6];
    
    char *outFile=NULL;
    
    // Default XPATH search strings:
    xmlChar *xpathSection  = (xmlChar*) "//*[name() = 'section']";
    xmlChar *xpathTable    = (xmlChar*) "//*[name() = 'table']";
    xmlChar *xpathFigure   = (xmlChar*) "//*[name() = 'figure']";
    xmlChar *xpathEquation = (xmlChar*) "//*[name() = 'equation']";
    
    // Command option flags:
    static int processTable = false;
    static int processFigure = false;
    static int processSection = false;
    static int processEquation = false;
    
    // Define the command line options:
    static struct option long_options[] = {
        /* These options don’t set a flag.
         We distinguish them by their indices. */
        {"table",   no_argument, &processTable,    't'},
        {"figure",  no_argument, &processFigure,   'f'},
        {"section", no_argument, &processSection,  's'},
        {"equation",no_argument, &processEquation, 'e'},
        {"prefix",  required_argument, 0,          'p'},
        {"xml",     required_argument, 0,          'x'},
        {"out-file",required_argument, 0,          'o'},
        {0, 0, 0, 0}
    };
    /* getopt_long stores the option index here. */
    int option_index = 0;
    /* dummy place holder as we iterate through the command line options */
    int intOption;
    
    
    // Check the incoming options through GNU getopt:
    while (true) {
        // First, get the next option:
        intOption = getopt_long (argc,
                                 argv,
                                 "tfsep:x:o:",
                                 long_options,
                                 &option_index);
        
        // Now detect what the user entered:
        if (intOption == -1) {
            // We've finished, so break out.
            break;
        }
        switch (intOption) {
            case 0:
                // We set a flag and nothing else:
                break;
            case 't':
                processTable = true;
                break;
            case 'f':
                processFigure = true;
                break;
            case 's':
                processSection = true;
                break;
            case 'e':
                processEquation = true;
                break;
            case 'x':
                docname = strdup(optarg);
                break;
            case 'p':
                prefix = strdup(optarg);
                break;
            case 'o':
                outFile = strdup(optarg);
                break;
            case '?':
                /* Hrmm, this is an error condition.  getopt_long should have
                 * dumped by now... */
                abort();
            default:
                abort();
        }
        
        
    }
    
    
    // Now the main body:
    
    // Initialise the random number generator
    srand(time(NULL));
    
    /* Do some sanity checks first:
     *  -) ensure prefix is set
     *  -) ensure docname is set
     */
    if (prefix == NULL) {
        fprintf(stderr, "Please set a prefix\n");
        exit(EXIT_FAILURE);
    }
    if (docname == NULL) {
        fprintf(stderr, "Please set the document to be processed\n");
        exit(EXIT_FAILURE);
    }
    
    /* open and parse the requested document.  Also do some error checking to
     * ensure that the document was correctly loaded and parsed. */
    fprintf(stdout, "Attempting to load and parse: %s\n", docname);
    doc = xmlParseFile(docname);
    if (doc == NULL ) {
        fprintf(stderr,"Document not parsed successfully. \n");
        abort();
    }
    
    
    /* Now search through the document using the xpath expression to find the
     * node/s of interest... */
    if (processEquation) {
        /* The following is a messy hack as the only difference between each
         * code loop is the "xpathEquation" section.  I'm just being lazy and
         * have not yet figured out libxml2's memory structures to push the new
         * nodes back to the doc element. */
        
        // First display some user help:
        fprintf(stdout, "Processing equations with the prefix: %s\n", prefix);
        
        
        result = getnodeset (doc, xpathEquation);
        if (result) {
            nodeset = result->nodesetval;
            for (i=0; i < nodeset->nodeNr; i++) {
                // This works for name at least:
                cur = nodeset->nodeTab[i];
                if ((hasAttr = xmlHasNsProp(cur,
                                            (const xmlChar *)"id",
                                            XML_XML_NAMESPACE)) == NULL) {
                    genAlphaID(IDRand, 5);
                    idToInsert = strdup(prefix);
                    strcat(idToInsert, "_");
                    strcat(idToInsert,"e");
                    strcat(idToInsert, "_");
                    strcat(idToInsert, IDRand);
                    fprintf(stdout, "Adding ID: %s\n",idToInsert);
                    newattr = xmlSetProp(cur,
                                         XML_XML_ID,
                                         (const xmlChar *)idToInsert);
                    free(idToInsert);
                    
                } // End if((hasAttr
            } // End for
        } // End if(result)
    } // End if(process
    
    if (processFigure) {
        /* The following is a messy hack as the only difference between each
         * code loop is the "xpathEquation" section.  I'm just being lazy and
         * have not yet figured out libxml2's memory structures to push the new
         * nodes back to the doc element. */
        
        // First display some user help:
        fprintf(stdout, "Processing figures with the prefix: %s\n", prefix);
        
        
        result = getnodeset (doc, xpathFigure);
        if (result) {
            nodeset = result->nodesetval;
            for (i=0; i < nodeset->nodeNr; i++) {
                // This works for name at least:
                cur = nodeset->nodeTab[i];
                if ((hasAttr = xmlHasNsProp(cur,
                                            (const xmlChar *)"id",
                                            XML_XML_NAMESPACE)) == NULL) {
                    genAlphaID(IDRand, 5);
                    idToInsert = strdup(prefix);
                    strcat(idToInsert, "_");
                    strcat(idToInsert,"f");
                    strcat(idToInsert, "_");
                    strcat(idToInsert, IDRand);
                    fprintf(stdout, "Adding ID: %s\n",idToInsert);
                    newattr = xmlSetProp(cur,
                                         XML_XML_ID,
                                         (const xmlChar *)idToInsert);
                    free(idToInsert);
                    
                } // End if((hasAttr
            } // End for
        } // End if(result)
    } // End if(process
    
    if (processTable) {
        /* The following is a messy hack as the only difference between each
         * code loop is the "xpathEquation" section.  I'm just being lazy and
         * have not yet figured out libxml2's memory structures to push the new
         * nodes back to the doc element. */
        
        // First display some user help:
        fprintf(stdout, "Processing tables with the prefix: %s\n", prefix);
        
        
        result = getnodeset (doc, xpathTable);
        if (result) {
            nodeset = result->nodesetval;
            for (i=0; i < nodeset->nodeNr; i++) {
                // This works for name at least:
                cur = nodeset->nodeTab[i];
                if ((hasAttr = xmlHasNsProp(cur,
                                            (const xmlChar *)"id",
                                            XML_XML_NAMESPACE)) == NULL) {
                    genAlphaID(IDRand, 5);
                    idToInsert = strdup(prefix);
                    strcat(idToInsert, "_");
                    strcat(idToInsert,"t");
                    strcat(idToInsert, "_");
                    strcat(idToInsert, IDRand);
                    fprintf(stdout, "Adding ID: %s\n",idToInsert);
                    newattr = xmlSetProp(cur,
                                         XML_XML_ID,
                                         (const xmlChar *)idToInsert);
                    free(idToInsert);
                    
                } // End if((hasAttr
            } // End for
        } // End if(result)
    } // End if(process
    
    if (processSection) {
        /* The following is a messy hack as the only difference between each
         * code loop is the "xpathEquation" section.  I'm just being lazy and
         * have not yet figured out libxml2's memory structures to push the new
         * nodes back to the doc element. */
        
        // First display some user help:
        fprintf(stdout, "Processing sections with the prefix: %s\n", prefix);
        
        
        result = getnodeset (doc, xpathSection);
        if (result) {
            nodeset = result->nodesetval;
            for (i=0; i < nodeset->nodeNr; i++) {
                // This works for name at least:
                cur = nodeset->nodeTab[i];
                if ((hasAttr = xmlHasNsProp(cur,
                                            (const xmlChar *)"id",
                                            XML_XML_NAMESPACE)) == NULL) {
                    genAlphaID(IDRand, 5);
                    idToInsert = strdup(prefix);
                    strcat(idToInsert, "_");
                    strcat(idToInsert,"s");
                    strcat(idToInsert, "_");
                    strcat(idToInsert, IDRand);
                    fprintf(stdout, "Adding ID: %s\n",idToInsert);
                    newattr = xmlSetProp(cur,
                                         XML_XML_ID,
                                         (const xmlChar *)idToInsert);
                    free(idToInsert);
                    
                } // End if((hasAttr
            } // End for
        } // End if(result)
    } // End if(process
    
    // Finally, save the document and clean up:
    if (outFile == NULL) {
        // No out file was specified, so overright
        xmlSaveFormatFile(docname, doc, 1);
    }
    else {
        xmlSaveFormatFile(outFile, doc, 1);
    }
    
    // Be nice and clean up before exiting
    xmlFreeDoc(doc);
    xmlCleanupParser();
    return (1);
}
