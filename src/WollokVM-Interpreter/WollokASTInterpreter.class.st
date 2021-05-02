Class {
	#name : #WollokASTInterpreter,
	#superclass : #Object,
	#instVars : [
		'bindings',
		'returnedValue',
		'executionStack'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #visiting }
WollokASTInterpreter >> activateMethod: method withReceiver: receiver withArguments: arguments [

	| returnValue |
	method	 isNative ifTrue: [
		"Manejar caso nativo"
		...
		^ self
	].

	"Manejar el caso de la ejecución normal con manejo de pila"
	executionStack push: (WollokFunctionScope newWithReceiver: receiver andArguments: arguments). 
	returnValue := method acceptVisitor: self.
	executionStack pop.
	^ returnValue
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

	executionStack := Stack new.
	executionStack push: WollokGlobalScope new.
	aFileNode main elements do: [ :e | lastValue := e acceptVisitor: self ].
	executionStack pop.
	^ lastValue	
]

{ #category : #testing }
WollokASTInterpreter >> isFalse: aWollokObject [

	^ aWollokObject isWollokFalse
]

{ #category : #testing }
WollokASTInterpreter >> isNull: anUndefinedObject [ 
	^ anUndefinedObject isNil
]

{ #category : #testing }
WollokASTInterpreter >> isTrue: aWollokObject [

	^ aWollokObject isWollokTrue
]

{ #category : #bindings }
WollokASTInterpreter >> lookup: aString in: aWollokVMClass [ 
	(aWollokVMClass methodNamed: aString) ifNotNil: [ :method | ^ method ].
	^ self lookup: aString in: (self resolve: aWollokVMClass superClassName).
]

{ #category : #bindings }
WollokASTInterpreter >> resolve: aString [ 
	
	^ bindings at: aString
]

{ #category : #bindings }
WollokASTInterpreter >> resolveVariable: aString [ 

	^ executionStack top variableValue: aString. 
]

{ #category : #visiting }
WollokASTInterpreter >> visitAssignment: aWollokAssignmentNode [
	| variableName variableValue |
	variableName := aWollokAssignmentNode variable name value.
	variableValue := aWollokAssignmentNode value acceptVisitor: self.
	executionStack top assignVariable: variableName withValue: variableValue
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
		
	aBinaryOperation operation value = '*'
		ifTrue: [ ^ self wollokNumberFrom: leftResult literalValue * rightResult literalValue ].
		
	aBinaryOperation operation value = '/'
		ifTrue: [ ^ self wollokNumberFrom: leftResult literalValue / rightResult literalValue ].
		
	aBinaryOperation operation value = '%'
		ifTrue: [ ^ self wollokNumberFrom: leftResult literalValue % rightResult literalValue ].
		
	aBinaryOperation operation value = '+'
		ifTrue: [ ^ self wollokNumberFrom: leftResult literalValue + rightResult literalValue ].
		
	aBinaryOperation operation value = '-'
		ifTrue: [ ^ self wollokNumberFrom: leftResult literalValue - rightResult literalValue ].
		
	aBinaryOperation operation value = '>'
		ifTrue: [ ^ self asWollokBoolean: leftResult literalValue > rightResult literalValue ].

	aBinaryOperation operation value = '<'
		ifTrue: [ ^ self asWollokBoolean: leftResult literalValue < rightResult literalValue ].
		
	self notYetImplemented
]

{ #category : #visiting }
WollokASTInterpreter >> visitBlockExpression: aWollokBlockExpressionNode [ 
	aWollokBlockExpressionNode expressions do: [:expression | expression acceptVisitor: self].
	^ returnedValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitBooleanLiteral: aWollokBooleanLiteralNode [
	
	^ self asWollokBoolean: aWollokBooleanLiteralNode value value = 'true'
]

{ #category : #visiting }
WollokASTInterpreter >> visitConstructorCall: aWollokConstructorCallNode [
	| wollokClass newObject initializeMethod |
	wollokClass := self resolve: (aWollokConstructorCallNode classRef asWollokQualifiedName).
	newObject := WollokVMObject new
		wollokClass: wollokClass;
		yourself.
	executionStack push: (WollokFunctionScope newWithReceiver: newObject).
	wollokClass allDeclarations do: [:declarationNode | declarationNode acceptVisitor: self].
	executionStack pop.
	initializeMethod := self lookup: 'initialize' in: wollokClass.
	initializeMethod isNotNil 
		ifTrue: [ self activateMethod: initializeMethod withReceiver: newObject withArguments: nil]. 
	^ newObject
		
]

{ #category : #visiting }
WollokASTInterpreter >> visitIfExpression: aWollokIfExpressionNode [ 
	| condition |
	condition := aWollokIfExpressionNode condition acceptVisitor: self.
	condition isWollokTrue 
		ifTrue: [ ^ aWollokIfExpressionNode then acceptVisitor: self ].
	condition isWollokTrue 
		ifFalse: [ ^ aWollokIfExpressionNode else acceptVisitor: self ].
]

{ #category : #visiting }
WollokASTInterpreter >> visitListLiteral: aWollokListLiteralNode [ 
	^ self wollokListFrom: (aWollokListLiteralNode listValue)
]

{ #category : #visiting }
WollokASTInterpreter >> visitMemberFeatureCall: aWollokMemberFeatureCallNode [ 
	
	| receiver arguments method |
	receiver := aWollokMemberFeatureCallNode receiver acceptVisitor: self.
	method := self lookup: aWollokMemberFeatureCallNode feature value in: receiver wollokClass.
	arguments := (aWollokMemberFeatureCallNode arguments with: method parameterNames collect: [ :valueNode :name |
		| value |
		value := valueNode acceptVisitor: self.
		name -> value 
		 ]) asDictionary.
	^ self activateMethod: method withReceiver: receiver withArguments: arguments
]

{ #category : #visiting }
WollokASTInterpreter >> visitMethodDeclaration: aWollokMethodDeclarationNode [ 
	^ aWollokMethodDeclarationNode expression acceptVisitor: self
]

{ #category : #visiting }
WollokASTInterpreter >> visitNumberLiteral: aWollokNumberLiteralNode [ 

	^ self wollokNumberFrom: aWollokNumberLiteralNode numberValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitReturnExpression: aWollokReturnExpressionNode [ 
	returnedValue := (aWollokReturnExpressionNode expression acceptVisitor: self)
]

{ #category : #visiting }
WollokASTInterpreter >> visitStringLiteral: aWollokStringLiteralNode [  

	^ self wollokStringFrom: aWollokStringLiteralNode stringValue
]

{ #category : #visiting }
WollokASTInterpreter >> visitSuperInvocation: aWollokSuperInvocationNode [ 
	| selector currentObject currentMethod currentMethodSuperclass superMethod arguments |
	currentMethod := aWollokSuperInvocationNode method.
	currentMethodSuperclass := currentMethod parent superclass asWollokQualifiedName.
	selector := currentMethod name value.
	superMethod := self lookup: selector in: (self resolve: currentMethodSuperclass).
	currentObject := executionStack top receiver.
	
	self flag: #todo. "This code resolving the arguments is the same that's on WollokASTInterpreter>>visitMemberFeatureCall:"
	arguments := (aWollokSuperInvocationNode arguments with: superMethod parameterNames collect: [ :valueNode :name |
		| value |
		value := valueNode acceptVisitor: self.
		name -> value 
		 ]) asDictionary.
	^self activateMethod: superMethod withReceiver: currentObject withArguments: arguments
]

{ #category : #visiting }
WollokASTInterpreter >> visitUnaryOperation: aWollokUnaryOperationNode [
	| operation rightOperand |

	operation := aWollokUnaryOperationNode operation.	
	rightOperand := aWollokUnaryOperationNode rightOperand acceptVisitor: self.
	
	self flag: #todo.
	operation value = '-'
		ifTrue: [ ^ rightOperand ].
	
	self notYetImplemented
]

{ #category : #visiting }
WollokASTInterpreter >> visitVariable: aWollokVariableNode [ 
	^ self resolveVariable: aWollokVariableNode name value
]

{ #category : #visiting }
WollokASTInterpreter >> visitVariableDeclaration: aWollokVariableDeclarationNode [
	executionStack top declareVariable: aWollokVariableDeclarationNode variableName withValue: (aWollokVariableDeclarationNode right ifNotNil: [:rightExpression | rightExpression acceptVisitor: self]).
]

{ #category : #literals }
WollokASTInterpreter >> wollokListFrom: aCollection [ 
	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.List');
		literalValue: aCollection;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokNumberFrom: anInteger [ 

	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.Number');
		literalValue: anInteger;
		yourself
]

{ #category : #literals }
WollokASTInterpreter >> wollokStringFrom: aString [ 
	^ WollokVMLiteral new
		wollokClass: (self resolve: 'wollok.lang.String');
		literalValue: aString;
		yourself
]
