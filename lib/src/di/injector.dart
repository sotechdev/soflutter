abstract interface class Injector {
  TService get<TService extends Object>();
  addSingleton<TService extends Object>(Function constructor);
  addScoped<TService extends Object>(Function constructor);
  addTransient<TService extends Object>(Function constructor);
}
