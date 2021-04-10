Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings',
		'returnedValue'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #visiting }
WollokASTInterpreter >> activateMethod: method withReceiver: receiver withArguments: arguments [

	method	 isNative ifTrue: [
		"Manejar caso nativo"
		...
		^ self
	].

	"Manejar el caso de la ejecución normal con manejo de pila"
	^ method acceptVisitor: self
]

{ #category : #bindings }
WollokASTInterpreter >> addBinding: aName value: aWollokVMClass [ 
	
	bindings at: aName put: aWollokVMClass
]

{ #category : #bindings }
WollokASTInterpreter >> addBindingOfClass: aName fromString: aString [

	WollokReducedLoader new addBindingOfClass: aName fromString: aString in: self
]

{ #category : #visiting }
WollokASTInterpreter >> asWollokBoolean: aPharoBoolean [
	
	^ aPharoBoolean
		ifTrue: [ WollokTrue new ]
		ifFalse: [ | boolean |
			boolean := WollokFalse new.
			boolean interpreter: self.
			boolean ]
]

{ #category : #interpreting }
WollokASTInterpreter >> initialize [

	super initialize.

	bindings := Dictionary new.
	
	WollokReducedLoader new loadInto: self
]

{ #category : #interpreting }
WollokASTInterpreter >> interpretProgram: aFileNode [ 

	| lastValue |

	aFileNode main elements do: [ :e | lastValue := e acceptVisitor: self ].

	^ lastValue	
]

{ #category : #testing }
WollokASTInterpreter >> isFalse: aWollokObject [

	^ aWollokObject isWollokFalse
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> isNull: anUndefinedObject [ 
	^ anUndefinedObject isNil
]

{ #category : #testing }
WollokASTInterpreter >> isTrue: aWollokObject [

	^ aWollokObject isWollokTrue
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> lookup: aString in: aWollokVMClass [ 
	^ aWollokVMClass methodNamed: aString
]

{ #category : #bindings }
WollokASTInterpreter >> resolve: aString [ 
	
	^ bindings at: aString
]

{ #category : #visiting }
WollokASTInterpreter >> visitBinaryOperation: aBinaryOperation [

	| leftResult rightResult |

	leftResult := aBinaryOperation leftOperand acceptVisitor: self.	
	rightResult := aBinaryOperation rightOperand acceptVisitor: self.
	
	aBinaryOperation operation value = '&&'
		ifTrue: [ ^ leftResult & rightResult ].
	
	aBinaryOperation operation value = '||'
		ifTrue: [ ^ leftResult | rightResult ].
		
	aBinaryOperation operation value = '==='
		ifTrue: [ ^ leftResult wollokIdenticalTo: rightResult ].
	
	self notYetImplemented
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitBlockExpression: aWollokBlockExpressionNode [ 
	aWollokBlockExpressionNode expressions do: [:expression | expression acceptVisitor: self].
	^ returnedValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [
	
	^ self asWollokBoolean: aWollokBooleanLiteralNode value value = 'true'
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitConstructorCall: aWollokConstructorCallNode [ 
	^ WollokVMObject new 
		wollokClass: (self resolve: (aWollokConstructorCallNode classRef asWollokQualifiedName));
		yourself
]

{ #category : #visiting }
WollokASTInterpreter >> visitMemberFeatureCall: aWollokMemberFeatureCallNode [ 
	
	| receiver arguments method |
	receiver := aWollokMemberFeatureCallNode receiver acceptVisitor: self.
	arguments := aWollokMemberFeatureCallNode arguments collect: [ :each |
		each acceptVisitor: self ].
	method := self lookup: aWollokMemberFeatureCallNode feature value in: receiver wollokClass.
	^ self activateMethod: method withReceiver: receiver withArguments: arguments
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitMethodDeclaration: aWollokMethodDeclarationNode [ 
	^ aWollokMethodDeclarationNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitReturnExpression: aWollokReturnExpressionNode [ 
	returnedValue := (aWollokReturnExpressionNode expression acceptVisitor: self)
]

{ #category : #'as yet unclassified' }
WollokASTInterpreter >> visitVariable: aWollokVariableNode [ 
	^ nil
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]
