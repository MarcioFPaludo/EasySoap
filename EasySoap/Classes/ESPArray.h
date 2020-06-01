//
//  ESPArray.h
//  EasySoap
//
//  Created by Márcio Fochesato Paludo on 06/02/20.
//

#import "ESPNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface ESPArray<__covariant NodeType: ESPNode *> : ESPNode <NSFastEnumeration>

@property (nonatomic, readonly) NSUInteger count;

- (NodeType)nodeAtIndex:(NSInteger)index;
- (NSInteger)indexOfNode:(NodeType)node;
- (void)addNode:(NodeType)node;
- (void)insertNode:(NodeType)node atIndex:(NSInteger)index;
- (void)removeNode:(NodeType)node;
- (void)removeNodeAtIndex:(NSInteger)index;

- (NodeType)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(NodeType)newValue atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
