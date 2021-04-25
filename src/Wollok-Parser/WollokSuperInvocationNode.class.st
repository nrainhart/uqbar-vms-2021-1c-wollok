Class {
	#name : #WollokSuperInvocationNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'superToken',
		'leftParenToken',
		'rightParenToken',
		'arguments',
		'commaTokens'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokSuperInvocationNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitSuperInvocation: self
]

{ #category : #generated }
WollokSuperInvocationNode >> arguments [
	^ arguments
]

{ #category : #generated }
WollokSuperInvocationNode >> arguments: anOrderedCollection [
	self setParents: self arguments to: nil.
	arguments := anOrderedCollection.
	self setParents: self arguments to: self
]

{ #category : #generated }
WollokSuperInvocationNode >> commaTokens [
	^ commaTokens
]

{ #category : #generated }
WollokSuperInvocationNode >> commaTokens: anOrderedCollection [
	commaTokens := anOrderedCollection
]

{ #category : #generated }
WollokSuperInvocationNode >> compositeNodeVariables [
	^ #(#arguments)
]

{ #category : #generated }
WollokSuperInvocationNode >> compositeTokenVariables [
	^ #(#commaTokens)
]

{ #category : #'generated-initialize-release' }
WollokSuperInvocationNode >> initialize [
	super initialize.
	arguments := OrderedCollection new: 2.
	commaTokens := OrderedCollection new: 2.
]

{ #category : #generated }
WollokSuperInvocationNode >> leftParenToken [
	^ leftParenToken
]

{ #category : #generated }
WollokSuperInvocationNode >> leftParenToken: aSmaCCToken [
	leftParenToken := aSmaCCToken
]

{ #category : #'as yet unclassified' }
WollokSuperInvocationNode >> method [
	self flag: #todo. "Asumes that every super call is two nodes inside of a method declaration - could break with a try/catch or other cases"
	^parent parent
]

{ #category : #generated }
WollokSuperInvocationNode >> rightParenToken [
	^ rightParenToken
]

{ #category : #generated }
WollokSuperInvocationNode >> rightParenToken: aSmaCCToken [
	rightParenToken := aSmaCCToken
]

{ #category : #generated }
WollokSuperInvocationNode >> superToken [
	^ superToken
]

{ #category : #generated }
WollokSuperInvocationNode >> superToken: aSmaCCToken [
	superToken := aSmaCCToken
]

{ #category : #generated }
WollokSuperInvocationNode >> tokenVariables [
	^ #(#superToken #leftParenToken #rightParenToken)
]
