import 'react-native-gesture-handler';
import React,{useEffect,useState} from 'react';
import {NavigationContainer,DefaultTheme} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {Ionicons} from '@expo/vector-icons';
import {StatusBar} from 'expo-status-bar';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {C} from './src/theme';
import {supabase} from './src/lib/supabase';
import AuthScreen from './src/screens/AuthScreen';
import HomeScreen from './src/screens/HomeScreen';
import ClientsScreen from './src/screens/ClientsScreen';
import ClientFormScreen from './src/screens/ClientFormScreen';
import ClientDetailScreen from './src/screens/ClientDetailScreen';
import LoanFormScreen from './src/screens/LoanFormScreen';
import LoanDetailScreen from './src/screens/LoanDetailScreen';
import PaymentScreen from './src/screens/PaymentScreen';
import CollectionsScreen from './src/screens/CollectionsScreen';
import ReportsScreen from './src/screens/ReportsScreen';
import ExpensesScreen from './src/screens/ExpensesScreen';
import RoutesScreen from './src/screens/RoutesScreen';
import DocumentsScreen from './src/screens/DocumentsScreen';
import MoreScreen from './src/screens/MoreScreen';
import PendingModuleScreen from './src/screens/PendingModuleScreen';
const Stack=createNativeStackNavigator(); const Tab=createBottomTabNavigator();
const icons={Início:'home-outline',Clientes:'people-outline',Cobranças:'alert-circle-outline',Relatórios:'bar-chart-outline',Mais:'menu-outline'};
function Tabs(){return <Tab.Navigator screenOptions={({route})=>({headerShown:false,tabBarActiveTintColor:C.pine,tabBarInactiveTintColor:C.soft,tabBarStyle:{height:70,paddingTop:6,paddingBottom:9,borderTopColor:C.line,backgroundColor:'#fff'},tabBarLabelStyle:{fontSize:11,fontWeight:'700'},tabBarIcon:({color,size})=><Ionicons name={icons[route.name]} color={color} size={size}/>})}><Tab.Screen name="Início" component={HomeScreen}/><Tab.Screen name="Clientes" component={ClientsScreen}/><Tab.Screen name="Cobranças" component={CollectionsScreen}/><Tab.Screen name="Relatórios" component={ReportsScreen}/><Tab.Screen name="Mais" component={MoreScreen}/></Tab.Navigator>}
export default function App(){const[session,setSession]=useState(undefined);useEffect(()=>{supabase.auth.getSession().then(({data})=>setSession(data.session));const {data:{subscription}}=supabase.auth.onAuthStateChange((_e,s)=>setSession(s));return()=>subscription.unsubscribe()},[]);if(session===undefined)return null;const theme={...DefaultTheme,colors:{...DefaultTheme.colors,background:C.bg,card:C.paper,text:C.ink,border:C.line,primary:C.pine}};return <SafeAreaProvider><NavigationContainer theme={theme}><StatusBar style="dark"/><Stack.Navigator screenOptions={{headerShown:false,contentStyle:{backgroundColor:C.bg}}}>{!session?<Stack.Screen name="Auth" component={AuthScreen}/>:<><Stack.Screen name="Tabs" component={Tabs}/><Stack.Screen name="ClienteForm" component={ClientFormScreen}/><Stack.Screen name="ClienteDetalhe" component={ClientDetailScreen}/><Stack.Screen name="EmprestimoForm" component={LoanFormScreen}/><Stack.Screen name="EmprestimoDetalhe" component={LoanDetailScreen}/><Stack.Screen name="Pagamento" component={PaymentScreen}/><Stack.Screen name="Despesas" component={ExpensesScreen}/><Stack.Screen name="Rotas" component={RoutesScreen}/><Stack.Screen name="Documentos" component={DocumentsScreen}/><Stack.Screen name="ModuloPendente" component={PendingModuleScreen}/></>}</Stack.Navigator></NavigationContainer></SafeAreaProvider>}
