//
//  ESPEnvelope.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 05/03/20.
//

#import "ESPEnvelope_Private.h"
#import "ESPNode.h"

#define kDefaultPrefix             @"soapenv"

static int MyXmlOutputWriteCallback(void * context, const char * buffer, int len);
static int MyXmlOutputCloseCallback(void * context);

static int MyXmlOutputWriteCallback(void * context, const char * buffer, int len)
{
    NSMutableData *theData = (__bridge NSMutableData *)context;
    [theData appendBytes:buffer length:len];
    return(len);
}

static int MyXmlOutputCloseCallback(void * context)
{
    return(0);
}

@interface ESPEnvelope ()

@property (nonatomic, retain) NSArray<ESPNode *> *parametters;
@property (nonatomic, retain) NSArray<ESPNode *> *headers;
@property (nonatomic, retain) NSString *nspace;
@property (nonatomic, retain) NSString *method;
@property (nonatomic) xmlDocPtr xmlDocument;

@end

@implementation ESPEnvelope

+ (instancetype)envelopWithString:(NSString *)string
{
    ESPEnvelope *envelope;
    xmlDocPtr document = xmlParseDoc((xmlChar *)[string UTF8String]);
    
    if (document != NULL) {
        if (document->children != NULL) {
            if ([ESPEnvelope findNodeWithName:"Body" parentNode:document->children] != NULL) {
                envelope = [[ESPEnvelope alloc] initWithMethod:@"" namespace:@"" parametters:@[]];
                envelope.xmlDocument = document;
            }
            else {
                xmlFreeDoc(document);
            }
        } else {
            xmlFreeDoc(document);
        }
    }
    
    return envelope;
}

- (instancetype)initWithMethod:(NSString *)method namespace:(NSString *)nspace parametters:(NSArray<ESPNode *> *)parametters
{
    return [self initWithMethod:method namespace:nspace headers:nil parametters:parametters];
}

- (instancetype)initWithMethod:(NSString *)method namespace:(NSString *)nspace headers:(NSArray<ESPNode *> *)headers parametters:(NSArray<ESPNode *> *)parametters
{
    self = [super init];
    
    if (self) {
        self.headers = headers;
        self.method = method;
        self.nspace = nspace;
        self.parametters = parametters;
    }
    
    return self;
}

- (void)dealloc
{
    if (_xmlDocument != NULL) {
        xmlFreeDoc(_xmlDocument);
    }
}

- (BOOL)hasFaultWithError:(NSError * _Nullable __autoreleasing *)error
{
    BOOL hasFault = NO;
    
    if (_xmlDocument != nil && [self bodyChildNode] != nil) {
        xmlNodePtr faultNode = [self findNodeWithName:"Fault"];
        if (faultNode != nil) {
            NSMutableData *theData = [[NSMutableData alloc] init];
            xmlOutputBufferPtr theOutputBuffer = xmlOutputBufferCreateIO(MyXmlOutputWriteCallback, MyXmlOutputCloseCallback, (__bridge void *)theData, NULL);
            xmlNodeDumpOutput(theOutputBuffer, _xmlDocument, faultNode, 0, 0, "utf-8");
            xmlOutputBufferFlush(theOutputBuffer);
            NSString *faultString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
            xmlOutputBufferClose(theOutputBuffer);
            
            *error = [NSError errorWithDomain:@"EasySoap.Request.Fault" code:500 userInfo:@{NSLocalizedDescriptionKey : faultString}];
            hasFault = YES;
        }
    }
    
    return hasFault;
}

- (xmlNodePtr)bodyChildNode
{
    xmlNodePtr bodyChild = NULL;
    
    if (_xmlDocument != NULL && _xmlDocument->children != NULL) {
        xmlNodePtr body = [self.class findNodeWithName:"Body" parentNode:_xmlDocument->children];
        if (body != NULL && body->children != NULL) {
            bodyChild = body->children;
        }
    }   
    
    return bodyChild;
}

- (xmlNodePtr)findNodeWithName:(const char *)name
{
    return [self bodyChildNode] != NULL ? [self.class findNodeWithName:name parentNode:[self bodyChildNode]] : NULL;
}

+ (xmlNodePtr)findNodeWithName:(const char *)name parentNode:(xmlNodePtr)parentNode
{
    while (parentNode != NULL && strcmp(name, (const char *)parentNode->name) != 0) {
        xmlNodePtr childrenNode = parentNode->children;
        parentNode = parentNode->next;
        
        while (childrenNode != NULL) {
            if (strcmp(name, (const char *)childrenNode->name) == 0) {
                parentNode = childrenNode;
                childrenNode = NULL;
            } else {
                childrenNode = childrenNode->next;
            }
        }
    }
    
    return parentNode;
}

#pragma mark - Serialization

- (NSString *)serialize
{
    NSMutableString *serializedString = [NSMutableString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:plan=\"%@\">", self.nspace];
    NSString *method = self.method;
    
    if (self.methodPrefix && self.methodPrefix.length > 0)
        method = [self.methodPrefix stringByAppendingFormat:@":%@", method];
    
    if (self.headers && self.headers.count > 0) {
        [serializedString appendString:@"<soapenv:Header>"];
        
        for (ESPNode *node in self.headers) {
            [serializedString appendString:node.serialize];
        }
        
        [serializedString appendString:@"</soapenv:Header>"];
    }
    else {
        [serializedString appendString:@"<soapenv:Header/>"];
    }
    
    [serializedString appendFormat:@"<soapenv:Body><%@>", method];
    
    for (ESPNode *node in self.parametters) {
        [serializedString appendString:node.serialize];
    }
    
    [serializedString appendFormat: @"</%@></soapenv:Body></soapenv:Envelope>", method];
    
    return serializedString;
}

@end
