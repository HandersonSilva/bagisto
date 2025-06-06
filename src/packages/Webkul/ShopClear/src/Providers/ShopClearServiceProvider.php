<?php

namespace Webkul\ShopClear\Providers;

use Illuminate\Support\ServiceProvider;

class ShopClearServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        $this->publishes([
            __DIR__ . '/../Resources/views' => resource_path('themes/shop-clear/views'),
        ]);
    }
}
