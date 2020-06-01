//
//  ESPArray.m
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 06/02/20.
//

#import "ESPArray.h"

@interface ESPArray ()

@property (nonatomic, readonly) NSMutableArray<ESPNode *> *nodes;

@end


@implementation ESPArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)serializeElements
{
    NSMutableString *elements = NSMutableString.string;
    
    for (ESPNode *node in _nodes) {
        if (!node.prefix || node.prefix <= 0) {
        node.prefix = self.prefix;
        }
        [elements appendString:[node serialize]];
    }
    
    return elements;
}

- (NSInteger)indexOfNode:(ESPNode *)node
{
    return [_nodes indexOfObject:node];
}

- (ESPNode *)nodeAtIndex:(NSInteger)index
{
    return [_nodes objectAtIndex:index];
}

- (void)addNode:(ESPNode *)node
{
    [_nodes addObject:node];
}

- (void)insertNode:(ESPNode *)node atIndex:(NSInteger)index
{
    [_nodes insertObject:node atIndex:index];
}

- (void)removeNode:(ESPNode *)node
{
    [_nodes removeObject:node];
}

- (void)removeNodeAtIndex:(NSInteger)index
{
    [_nodes removeObjectAtIndex:index];
}

- (ESPNode *)objectAtIndexedSubscript:(NSUInteger)index
{
    return [_nodes objectAtIndexedSubscript:index];
}

- (void)setObject:(ESPNode *)newValue atIndexedSubscript:(NSUInteger)index
{
    [_nodes setObject:newValue atIndexedSubscript:index];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)count
{
    return _nodes.count;
}

- (NSUInteger)countByEnumeratingWithState:(nonnull NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained * _Nonnull)buffer count:(NSUInteger)len
{
    return [_nodes countByEnumeratingWithState:state objects:buffer count:len];
}

@end
